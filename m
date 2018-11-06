From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v14 00/12] Enable cpuset controller in default hierarchy
Date: Tue, 6 Nov 2018 06:11:14 -0800
Message-ID: <20181106141114.GA2351522@devbig004.ftw2.facebook.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
 <20181106115335.GQ22431@hirez.programming.kicks-ass.net>
 <20181106115558.GB22485@hirez.programming.kicks-ass.net>
 <8c386375-b801-8adb-602e-40c73a7efedc@redhat.com>
 <CAOS58YPye=7Ga+y-ujFsgHqo6vdVnjykmON1z+UjNQLvvM_g4w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gdt1kJmntyurggHbrPSal7IcRdlpLMCs8QQ+tTT63wQ=;
        b=nFnkRYgCfWmZoENAc3hxQqb3oem6Dqi1Fzsjl34P34GjlCAWv2dUbLNpLZlJtN0A2R
         SPCHRYNCW4HUjQlkH29zJwyff0RK8VU3U9fYfmlhcNzy9HQZtinG8ov+ZwsGSXH72sKB
         blQQgIPRbLC3hp97L5UoehkD+SRiodlQoAdNN6SO8d5mwdvhfzjVlL5bKB4cSlIP7wa1
         xiBr6WH8NpVqZyyZY1Z97Cx2tw9An4K3aLgy6IF/Fky5cBqxmiORnf7T/wUajQVMAJRP
         qR6BiC4eJAGklw063yi1o6DY0YFcPFMNzi6jyLHBdFXUfMFy7FICkv314Ws6a5dp1n+N
         GFgg==
Content-Disposition: inline
In-Reply-To: <CAOS58YPye=7Ga+y-ujFsgHqo6vdVnjykmON1z+UjNQLvvM_g4w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

Hello, again, guys.

On Tue, Nov 06, 2018 at 09:09:07AM -0500, Tejun Heo wrote:
> Hello, Waiman, Peter.
> 
> Let's skip this patch for now. I'll think more about the interface and
> adapt your patch later.

Sorry about the last message.  I thought I configured web interface
but obviously didn't and it went out with html subpart.

Thanks.

-- 
tejun
