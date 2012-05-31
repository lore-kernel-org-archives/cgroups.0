From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH -V7 02/14] hugetlbfs: don't use ERR_PTR with VM_FAULT*
 values
Date: Wed, 30 May 2012 23:50:18 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205302331380.25774@chino.kir.corp.google.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205301801060.25774@chino.kir.corp.google.com>
 <20120531054533.GE24855@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=3MueL/pcMxdugeigNIEqWk+v2m9w0ZNJt7bT89WweOc=;
        b=oHPso4Nrzu46+KQMHRnHgBLRXQevJ59H2kZ+AbCvsKnWaB1P97s04UkaINM6b12ouV
         bLPtEnhcPaMq/4KnJcn8mHebwIXyEe2EIjehYS+oEN6ygkvo+l7jx8Y+F19McIiVrBps
         orDsr91jdhp8s7ujwMGmc5HJsIplH3Sr3Zpk+r+EXs9y1VER5e6lfONh6xijgwnBiaqR
         VNpIuUE7eYJ8Q2icuYcIyMyWbJBfYnhM53wnJI1J9ZYZHavxfVlwEp4AD9UPvMy5c1D2
         i1Tve8H0mX7bYyVYQ5GymeDC0ryjqM5HWAlfM3YB6w4AhblgiYee0gtT8C4yMHfzOdiy
         GmzA==
In-Reply-To: <20120531054533.GE24855@skywalker.linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>

On Thu, 31 May 2012, Aneesh Kumar K.V wrote:

> > Yeah, but is there a reason for using VM_FAULT_HWPOISON_LARGE_MASK since 
> > that's the only VM_FAULT_* value that is greater than MAX_ERRNO?  The rest 
> > of your patch set doesn't require this, so I think this change should just 
> > be dropped.  (And PTR_ERR() still returns long, this wasn't fixed from my 
> > original review.)
> > 
> 
> The changes was done as per Andrew's request so that we don't have such hidden
> dependencies on the values of VM_FAULT_*. Yes it can be a seperate patch from
> the patchset. I have changed int to long as per your review.
> 

I think it confuscates the code, can't we just add something like 
BUILD_BUG_ON() to ensure that PTR_ERR() never uses values that are outside 
the bounds of MAX_ERRNO so we'll catch these at compile time if 
mm/hugetlb.c or anything else is ever extended to use such values?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
