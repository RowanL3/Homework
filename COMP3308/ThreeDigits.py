list(filter(lambda x: sqrt(x) == int(sqrt(x)),[10*c**2 +10*c*b - 2*b**2 for b,c in product(range(1,1000),range(1,10000))]))

from sys import argv
from itertools import product

MAX_ATTEMPTS = 1000

def add1(x): 
    return x + 1
def sub1(x): 
    return x - 1 

class StateTree:
    def __init__(self, start, goal, forbidden):   
        self.forbidden = forbidden
        self.fringe = [GameState(start, 0, None, None)]
        self.expanded = []
        self.goal = goal

    def goal_distance(self, state):
        return sum(abs(x - y) for x, y in zip(state.number, self.goal))

    def generic_search(self, selector):
        for _ in range(MAX_ATTEMPTS):
            if len(self.fringe) == 0:
                return None

            to_expand = selector()

            self.expanded.append(to_expand)
            self.fringe.remove(to_expand)
            
            if to_expand.number == self.goal:
                return to_expand

            substates = to_expand.get_substates(self.forbidden, self.expanded)

            self.fringe += substates

    def best_first_selector(self):
        min_cost = min(state.cost for state in self.fringe)
        min_cost_states = [state for state in self.fringe if state.cost == min_cost]
        return min_cost_states[0]

    def greedy_selector(self):
        min_distance = min(self.goal_distance(state) for state in self.fringe)
        min_distance_states = [state for state in self.fringe if self.goal_distance(state) == min_distance]
        return min_distance_states[-1]

    def a_star_selector(self):
        min_h = min(self.goal_distance(state) + state.cost for state in self.fringe)
        min_h_states = [state for state in self.fringe if self.goal_distance(state) + state.cost == min_h]
        return min_h_states[-1]

    def depth_first_selector(self):
        max_depth = max(state.cost for state in self.fringe)
        max_depth_states = [state for state in self.fringe if state.cost == max_depth]
        return max_depth_states[0]

    def best_frist_search(self):
        return self.generic_search(self.best_first_selector)

    def a_star_search(self):
        return self.generic_search(self.a_star_selector)

    def greedy_search(self):
        return self.generic_search(self.greedy_selector)  

    def depth_first_search(self):
        return self.generic_search(self.depth_first_selector) 

    def iterative_deepening_search(self):
        current_depth = 0
        start = self.fringe[:]
        current_expanded = list()
        for _ in range(MAX_ATTEMPTS):
            if len(self.fringe) == 0:
                current_depth += 1
                self.fringe = start[:]
                current_expanded = list()
        
            to_expand = self.depth_first_selector()

            self.expanded.append(to_expand)
            current_expanded.append(to_expand)
            self.fringe.remove(to_expand)
            
            if to_expand.number == self.goal:
                return to_expand

            if to_expand.cost < current_depth:
                substates = to_expand.get_substates(self.forbidden, current_expanded)
                self.fringe += substates

    def hill_climbing_search(self):
        current = self.fringe[0]
        for _ in range(MAX_ATTEMPTS):
            self.expanded.append(current)
            if current.number == self.goal:
                return current
            substates = current.get_substates(self.forbidden, [])

            lower_states = [substate for substate in substates if self.goal_distance(substate) < self.goal_distance(current)]
    
            if lower_states:
                current = lower_states[-1]
            else:
                break


class GameState:
    def __init__(self, number, cost, parent, prev_move):
        self.number = number
        self.prev_move = prev_move
        self.cost = cost
        self.parent = parent

    def __eq__(self,other):
        if other == None:
            return False
        else:
            return self.prev_move == other.prev_move and self.number == other.number 

    def __str__(self):
        return "".join(str(digit) for digit in self.number)

    def new_substate(self, place, operator):
        state_number = self.number[:]
        state_number[place] = operator(state_number[place])
        return GameState(state_number,self.cost + 1, self, place)

    def get_substates(self, forbidden, expanded):
        substates = list()
        for place, operator in product([0, 1, 2], (sub1, add1)):
            substate = self.new_substate(place, operator)
            if place != self.prev_move and \
                substate.number not in forbidden and \
                substate not in expanded and \
                all(x in range(10) for x in substate.number):
                substates.append(substate)
        return substates

    def get_path(self):
        if self.parent == None:
           return [self]
        else:
            return self.parent.get_path() +[self]
  


def main(alg,start,end,forbidden = []):
    """

    >>> p, e = main('B',[3,2,0],[1,1,0])
    >>> p
    '320,220,210,110'
    >>> e
    '320,220,420,310,330,321,210,230,221,410,430,421,210,410,311,230,430,331,221,421,311,331,110'
    >>> p, e = main('D',[3,2,0],[1,1,0])
    >>> p
    '320,220,210,110'
    >>> e
    '320,220,210,110'
    >>> p, e = main('G',[3,2,0],[1,1,0])
    >>> p
    '320,310,210,211,111,110'
    >>> e
    '320,310,210,211,111,110'
    >>> p, e = main('A',[3,2,0],[1,1,0])
    >>> p
    '320,220,210,110'
    >>> e
    '320,310,210,220,210,110'
    >>> p, e = main('I',[3,2,0],[1,1,0])
    >>> p
    '320,220,210,110'
    >>> e
    '320,320,220,420,310,330,321,320,220,210,230,221,420,410,430,421,310,210,410,311,330,230,430,331,321,221,421,311,331,320,220,210,110'
    >>> p, e = main('H',[3,2,0],[1,1,0])
    >>> p
    'No solution found.'
    >>> e
    '320,310,210'
    """
    st = StateTree(start, end, forbidden)

    if alg == 'G': 
        goal = st.greedy_search()
    elif alg == 'B': 
        goal = st.best_frist_search()
    elif alg == 'A':
        goal = st.a_star_search()
    elif alg == 'D': 
        goal = st.depth_first_search()
    elif alg == 'I': 
        goal = st.iterative_deepening_search()
    elif alg == 'H': 
        goal = st.hill_climbing_search()

    if goal:
        path = ",".join(str(state) for state in goal.get_path())
    else:
        path = "No solution found."

    expanded = ",".join(str(state) for state in st.expanded)
    
    return path, expanded

def read_file(filename):
    # Trapping ain't dead, my connect still breathing.
    with open(filename) as f:
        start, end, forbidden = (line.strip() for line in f.readlines()[:3])

        start = [int(digit) for digit in list(start)]
        end = [int(digit) for digit in list(end)]
        forbidden = [[int(digit) for digit in list(number)] for number in forbidden.split(",")]
        print(start, end, forbidden)
    
    return start, end, forbidden

if __name__ == "__main__":
    import doctest
    doctest.testmod()
    path, expanded = main(argv[1],*read_file(argv[2]))
    print(path)
    print(expanded)
