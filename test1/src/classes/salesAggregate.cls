public with Sharing class salesAggregate
{

    public String getPpp() {
        return aabbcc.ddeeff();
    }

   public list<AggregateResult> lstAgg = new list<AggregateResult>();
   public salesAggregate()
   {
   
       lstAgg = [SELECT StageName, SUM(Amount) Amount, COUNT(id) Total
                 FROM Opportunity
                 WHERE isClosed = false
                 AND StageName != 'Canceled'
                 GROUP BY StageName
                 ];
   }

   public list<OppAgg> getResults()
   {
       list<OppAgg> lstResult = new list<OppAgg>();
       for (AggregateResult ar: lstAgg)
       {
           OppAgg objOppAgg = new OppAgg(ar);
           lstResult.add(objOppAgg);
       }
       return lstResult;
   }

   class OppAgg
   {
       public Integer Total {get;set;}
       public String StageName {get;set;}
       public Decimal Amount {get;set;}
       public OppAgg(AggregateResult ar)
       {
           Total = (Integer)ar.get('Total');
           StageName = (String)ar.get('StageName');
           Amount = (Decimal)ar.get('Amount');
       }
   }
}