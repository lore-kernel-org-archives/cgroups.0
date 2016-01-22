From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.5-fixes] cpuset: make mm migration
 asynchronous
Date: Fri, 22 Jan 2016 10:47:25 -0500
Message-ID: <20160122154725.GF32380@htj.duckdns.org>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org>
 <5698A023.9070703@de.ibm.com>
 <20160115164023.GH3520@mtj.duckdns.org>
 <20160119171841.GP3520@mtj.duckdns.org>
 <56A23BA8.1040403@de.ibm.com>
 <20160122152232.GB32380@htj.duckdns.org>
 <56A24EAD.1010507@de.ibm.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Kc0x1aoRpEsKNceoZvFFlZUp18/pIa2lanFx4+2IxWQ=;
        b=RhTr+MsJ7Co28UMw9EL6OWzPo6ItKEbS552HcOQ19LOWN63NlveRwoBrV66DNHrU8s
         MtGbHh5SdcAZ4qHSwM5J9NSgiKuWYYfljNZuXn9N5BSdVYEII9RbJ+JeByKnF6vOegFE
         piuVd05xaSjPaZ49guUqnEjmtcd3u2IPS+qp4E8MYAT2RPTmFUbRfeINBcpD08b2cpY1
         P8EpEHGfD0CophaTdK7hguVKJCmU4jjHB6oQcGovIa7HNLu5oKL6RgNuQ1nP/Agja+4y
         nHiVZJOgL0CkUpc9Kci5doD+2VgNg7At9yqpwDKxr07wxz6Au3MQcOgpGDqTYkqgxqvI
         g3LA==
Content-Disposition: inline
In-Reply-To: <56A24EAD.1010507@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, cgroups@vger.kernel.org, kernel-team@fb.com

On Fri, Jan 22, 2016 at 04:45:49PM +0100, Christian Borntraeger wrote:
> On 01/22/2016 04:22 PM, Tejun Heo wrote:
> > Hello, Christian.
> > 
> > On Fri, Jan 22, 2016 at 03:24:40PM +0100, Christian Borntraeger wrote:
> >> Hmmm I just realized that this patch slightly differs from the one that
> >> I tested. Do we need a retest?
> > 
> > It should be fine but I'd appreciate if you can test it again.
> 
> I did restart the test after I wrote the mail. The latest version from this mail
> thread is still fine as far as I can tell.

Thanks a lot.  Much appreciated.

-- 
tejun
