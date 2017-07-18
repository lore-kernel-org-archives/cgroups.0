From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Tue, 18 Jul 2017 20:41:35 +0200
Message-ID: <20170718184135.auf6d2clsdxseka3@hirez.programming.kicks-ass.net>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <20170717142609.GC3519177@devbig577.frc2.facebook.com>
 <20170718172801.f56273tzgzn3xkne@hirez.programming.kicks-ass.net>
 <20170718175456.GH585283@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7S78YSjd49axN6msAdUc8rzV7aCOHtDdMpUXRSrwv7E=; b=Afx0AJBh4afhksJRwycAL6xfB
        JHyiYuE9P4dnf9XIt0QbJHiDx48eMkFe2kGnjffmsgbII/bwQjfi80hGJQ28AxxofpvQ9oDiTEeN4
        0umqKnByRGq6NjvXPAPO4DrVonkX+5vggChp279ishurbk35MMwa+Ou/RN/AjEyx/31+ZYQN764uE
        DU3Yoj4OBokclh8jp+Six5obnWQdjcwtXAW3+ZVkk5ybttKK3Ip2V5utweyrHh0CuvN2JotXYVPwn
        0RxOG70RYo3951pWIHSsBKclWjOBpjUpUqfzUIPFEeNTAX7bohMxB1tQEvqoD4UoKzM/AlQ/DVQf0
    
Content-Disposition: inline
In-Reply-To: <20170718175456.GH585283@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Tue, Jul 18, 2017 at 01:54:56PM -0400, Tejun Heo wrote:

> Okay, we're kinda off the rails now.  Just to verify that we're on the
> same page, are you also saying that the following should be a valid
> configuration?
> 
> 	R (D)
>         |
> 	A (D and has processes in it and controllers enabled)
>         |
>         C (D and has processes in it) 
> 

Argh, the no internal process thing again -- I completely forgot about
that :-(


