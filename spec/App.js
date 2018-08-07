import React from 'react';
import ReactDOM from 'react-dom';
import Header from './components/Header';
import PidForm from './components/PidForm';
class App extends React.Component {
  // state = {
  //   pid: '',
  //   vpid: ''
  // };

  render() {
    return (
      <div>
        <Header title={'VIDEO OPTIONS'} />
        <PidForm />
      </div>
    );
  }
}
// const App = () => {
//   return (
//     <div>
//       <Header title={'VIDEO OPTIONS'} />
//       <PidForm />
//     </div>
//   );
// };
export default App;
ReactDOM.render(<App />, document.getElementById('app'));
