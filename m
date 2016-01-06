From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4.4-rc7] sched: move sched lock synchronized bitfields
 in task_struct into ->atomic_flags
Date: Wed, 6 Jan 2016 08:44:53 -0500
Message-ID: <20160106134453.GB29797@mtj.duckdns.org>
References: <20150921200141.GH13263@mtj.duckdns.org>
 <20151125144354.GB17308@twins.programming.kicks-ass.net>
 <20151125150207.GM11639@twins.programming.kicks-ass.net>
 <CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
 <20151125174449.GD17308@twins.programming.kicks-ass.net>
 <20151211162554.GS30240@mtj.duckdns.org>
 <20151215192245.GK6357@twins.programming.kicks-ass.net>
 <20151230092337.GD3873@htj.duckdns.org>
 <CA+55aFx0WxoUPrOPaq3HxM+YUQQ0DPV-c3f8kE1ec7agERb_Lg@mail.gmail.com>
 <20160101025628.GA3660@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fjHQ8i+FS5apcpSkEId/rpfBUQgeB6iYgnL1vqBm+Lk=;
        b=0zkXspBlx1BW1NoKqcIB3gTBDnjtDp1lo/Td2vQEmHs4b/F85pBf4dWEEbLkbIeqxm
         rG//fPesTu/XPKN2a85037/MFy7RWrQhgufa2bVB6ApgwpYnn0Sfw8hrRpImtq2IcvVh
         J1zbYL6322V48+v9yXJfnjAMspaMh/HP6ePC1mx/OS3KJGahSMcYNeeJA5wFDxwLPoCk
         9OWZbA3L6uOSbKfJg5qDujxpKDKHokj+sWLuiQ3HF3ke611+VqEEm6VmYaYOI2gNTTp2
         4rMqOdBHvCfFNMug2xaLXMnkgNSYe97AuoH26IWhdoAt0kEv2ZNqvvH7ew2cu1E4DdH+
         ewlA==
Content-Disposition: inline
In-Reply-To: <20160101025628.GA3660-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Dec 31, 2015 at 09:56:28PM -0500, Tejun Heo wrote:
> task_struct has a cluster of unsigned bitfields.  Some are updated
> under scheduler locks while others are updated only by the task
> itself.  Currently, the two classes of bitfields aren't distinguished
> and end up on the same word which can lead to clobbering when there
> are simultaneous read-modify-write attempts.  While difficult to prove
> definitely, it's likely that the resulting inconsistency led to low
> frqeuency failures such as wrong memcg_may_oom state or loadavg
> underflow due to clobbered sched_contributes_to_load.

Ping.

-- 
tejun
