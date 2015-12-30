From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v4.4-rc7] sched: isolate task_struct bitfields according
 to synchronization domains
Date: Wed, 30 Dec 2015 12:17:48 -0800
Message-ID: <CA+55aFxFBKx5qo67qDcBdeH3pk6sjVAi-iAtYO7bgpoyJM4Fyw@mail.gmail.com>
References: <20150913185940.GA25369@htj.duckdns.org>
	<55FEC685.5010404@oracle.com>
	<20150921200141.GH13263@mtj.duckdns.org>
	<20151125144354.GB17308@twins.programming.kicks-ass.net>
	<20151125150207.GM11639@twins.programming.kicks-ass.net>
	<CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
	<20151125174449.GD17308@twins.programming.kicks-ass.net>
	<20151211162554.GS30240@mtj.duckdns.org>
	<20151215192245.GK6357@twins.programming.kicks-ass.net>
	<20151230092337.GD3873@htj.duckdns.org>
	<CA+55aFx0WxoUPrOPaq3HxM+YUQQ0DPV-c3f8kE1ec7agERb_Lg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=gYvPRkVB/RqyZN4MMIim7XX7UATB9T116NPPjpZPXQY=;
        b=vVrMrVRbu0QzbYQrSteKf7SR1VVtB1OeSn2p/TSBt3HR7w1hYcH3p8MK4v8cikVvWX
         uaEKeyoJced8Q45rchBXecH1t3azT4KAc2dlx9ogcow993oBsALCdHMCp0fL9JxwQ1GE
         e8ZZ3AZtjAWTuHAc7dqzN/Y9VhpgbfPLzxdV+awWvwIPYyGSqCsYFW8k8O+NxO26/tWD
         ZVXYqyQPhB2V5ynZyOKJS4l0QNXmsfrWLDEoyXfGe73KFW3jM5wjKigbTXC07iWL4s75
         Alzhf2PC6/xP5hnODL6gAXabZtNb0auxN9seBx4l1Nk7dLlS62rr/wLyv9LVNQa/BAWJ
         tgXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=gYvPRkVB/RqyZN4MMIim7XX7UATB9T116NPPjpZPXQY=;
        b=Zb/HxE2mXoJyySxjOaazFUQpwJMtEDquI4ArF5/hsMABTs+b7tc48fIW+ZPu1SQL2/
         7QT0C6wg7sD5Nq4O7hsyUw+dkYRflsBwtaoH3KX9z/99p28A1P6m9802h7BI+8tum1Rf
         gA0vxrW9ojjSr21TYQ3q9dlUPnPwiVgfDbGc8=
In-Reply-To: <CA+55aFx0WxoUPrOPaq3HxM+YUQQ0DPV-c3f8kE1ec7agERb_Lg@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Ingo Molnar <mingo@redhat.com>, Sasha Levin <sasha.levin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Vladimir Davydov <vdavydov@parallels.com>, kernel-team <kernel-team@fb.com>, Dmitry Vyukov <dvyukov@google.com>, Peter Zijlstra <peterz@infradead.org>

On Wed, Dec 30, 2015 at 12:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Also, quite frankly, since this is basically very close to other
> fields that are *not* unsigned longs, I'd really prefer to not
> unnecessarily use a 64-bit field for three bits each.

Side note: I don't hate the patch. I think it's a good catch, and
would take it as-is. I just think it could be better.

               Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
