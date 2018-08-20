/*
 * silly.c
 * Don't worry about what it does.
 * Just make it compile without warnings
 */


//Don't touch the code below this line

int main(int argc, char **argv)
{
	if (argc != 2)
	{
		fprintf(stderr, "USAGE: %s <countdownLen>\n", argv[0]);
		return 1;
	}

	int i = atoi(argv[1]);

	printf("Counting down:");
	while (i > 0)
	{
		printf(" %d", i);
		fflush(NULL);

		sleep(1);
		i--;
	}
	printf(" done.\n\n");


	printf("Downloading http://www.cs.arizona.edu/...\n\n");
	fflush(NULL);


	/* look up the IP address of the host */
	struct hostent *host = gethostbyname("www.cs.arizona.edu");
	if (host == NULL)
	{
		perror("Could not look up the DNS name");
		return 1;
	}

	/* create the socket address struct, which we'll use (in just a
	 * moment) to connect the socket.  At the end, we'll "end" the
	 * hostent usage.  This doesn't clean up any memory (it's
	 * probably static memory), but it closes a no-longer-needed
	 * socket.
	 *
	 * See the man page for details.
	 */
	struct sockaddr_in addr;
	memset(&addr, 0, sizeof(addr));

	addr.sin_family      = AF_INET;
	addr.sin_addr.s_addr = *(int*)host->h_addr_list[0];  // get the first IP address
	addr.sin_port        = htons(80);

	if (system("nslookup www.cs.arizona.edu") == -1)
	{
		perror("Could not run nslookup");
		return 1;
	}
	printf("Addr = 0x%08x\n", addr.sin_addr.s_addr);

	endhostent();


	/* create the socket and connect it to the (remote) server */

	int sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock == -1)
	{
		perror("Could not create the socket");
		return 1;
	}

	if (connect(sock, (struct sockaddr*)&addr, sizeof(addr)) != 0)
	{
		perror("Could not bind the socket");
		return 1;
	}


	/* send the HTTP command; then mark the socket as closed (on, the
	 * outgoing side) immediately.
	 */
	char *request = "GET /\n";
	if (send(sock, request, strlen(request), 0) != strlen(request))
	{
		perror("Could not send request");
		return 1;
	}

	if (shutdown(sock, SHUT_WR) != 0)
	{
		perror("Could not shut down the write-side of the socket");
		return 1;
	}


	/* read all data and echo it to the user */

	while (1)   // we'll break out manually
	{
		char buf[4096];

		// note the -1 in the length, so that we can tack on
		// a null terminator at the end.  If we didn't do this,
		// then we'd have to use fwrite() instead of printf(),
		// and then I'd have to worry about whether fwrite()
		// and printf() were using the same outgoing buffers.
		// This is simpler, IMHO.

		int rc = recv(sock, buf, sizeof(buf)-1, 0);
		if (rc == 0)
		{
			// normal condition, this is EOF on the socket
			break;
		}

		if (rc < 0)
		{
			// error condition
			perror("Error reading from the socket");
			return 1;
		}

		// normal read of (some) data.  Tack on the null
		// terminator, and we can print.
		buf[rc] = '\0';

		printf("%s", buf);
		fflush(NULL);
	}


	printf("\n");
	printf("All done OK!\n");

	return 0;
}

