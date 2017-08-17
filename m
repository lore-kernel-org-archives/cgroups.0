From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource
 accounting
Date: Thu, 17 Aug 2017 06:01:58 -0700
Message-ID: <20170817130158.GB3238792@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170816185241.GF4087514@devbig577.frc2.facebook.com>
 <20170817081304.ebdeh56tonm5fjgt@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EmzhjtCDZeHxjpGNPtkhN+n+rHhULMMnaQi0dV8qd+4=;
        b=UHY0c/uTruGqIJXUL5SxtIMO+OGCGB1CiTQrx97jwbxKrFOfFWmH89ZONPCctXZq6f
         yjfc92+bhsnsgUr/6kxDGVROTvv5CFUsr6RKbuKw51xDJ+iNNLouTUvQbu3uVQBD1dwQ
         wsGwoADnQwmBLgxLLoKoZjiLkeFUEIrIJtZiy4SMsowKTRKFUJzZ7LWy76pDOW3IgSQG
         eEykv33ZKlq7NTDJk/vsSHTa9cX5qRHE72XqBK2hmXNydaXjoa4EyMatNvsFObP6N/ub
         RswRXhjzXMv5wI3jmh7Ukccc1XEmTRbhP5WeVTUON5JmwZDs6aQ4oO93gDmJc3NqWWEt
         uLaw==
Content-Disposition: inline
In-Reply-To: <20170817081304.ebdeh56tonm5fjgt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello, Ingo.

On Thu, Aug 17, 2017 at 10:13:04AM +0200, Ingo Molnar wrote:
> Please hold off on applying it before PeterZ gets back from vacation and has had a 
> chance to review it.

Of course.  These aren't going anywhere without Peter's explicit acks.

Thanks.

-- 
tejun
