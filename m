From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Date: Sat, 9 Jun 2012 18:55:30 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206091853580.7832@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com> <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
 <87lik920h8.fsf@skywalker.in.ibm.com> <20120608160612.dea6d1ce.akpm@linux-foundation.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu) <87zk8cfu3v.fsf@skywalker.in.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=0Wf909rgUDlKfq8pfsJAbX09Qjm8DXbR1l4R88pcuT4=;
        b=HTsteQI9MjA671ANOMr9Po0+fLQ8VvPFACnYh6kR2FP2Z41JD5bCInGRb6nbcChSIH
         j40w/bIzoFaL9dJAqP3WjyA009kXstgv+sswVMUaKcXk+LgrEwei4tuEAZ7gXWioY0rh
         6dF4aM1ekJtOrZY5hHitH9zPOiZgB/D240T0jNZ+8wj1TySmt5G4+05BRrzBaVgYh2ZP
         FO9ccheGUVQVATYeRWbzSpQ4TIBX/OhqwlRHX0O8gDG8MOOH19TNVr9Vc8e3GLl6JReJ
         vvxmJZ7moNkKSWFxM9SKNQt+KNahkvIjyiI+or1OsWWWaT1Wjh4dpvifXPYyF2ReOblD
         CAEg==
In-Reply-To: <87zk8cfu3v.fsf@skywalker.in.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, mgorman@suse.de, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, dhillf@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>

On Sat, 9 Jun 2012, Aneesh Kumar K.V wrote:

> David Rientjes didn't like HugetTLB limit to be a memcg extension and
> wanted this to be a separate controller. I posted a v7 version that did
> HugeTLB limit as a separate controller and used page cgroup to track
> HugeTLB cgroup. Kamezawa Hiroyuki didn't like the usage of page_cgroup
> in HugeTLB controller( http://mid.gmane.org/4FCD648E.90709@jp.fujitsu.com )
> 

Yes, and thank you very much for working on v8 to remove the dependency on 
page_cgroup and to seperate this out.  I think it will benefit users who 
don't want to enable all of memcg but still want to account and restrict 
hugetlb page usage, and I think the code seperation is much cleaner 
internally.

I'll review that patchset and suggest that the old hugetlb extension in 
-mm be dropped in the interim.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
