From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource
 accounting
Date: Thu, 17 Aug 2017 10:13:04 +0200
Message-ID: <20170817081304.ebdeh56tonm5fjgt@gmail.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170816185241.GF4087514@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=trATM04j3kSAJW0W7lrhh86kNCUl5c4vyM/JeX5pjGY=;
        b=mM9hY5pF2gMGMfpNlP8friyA1tAVuH9hpZB5A7gsr/KI7yTVEZT1EpCQtUrkDfp0uT
         vGNLMqy4GVkP0xaS0AFqVrZwAUDZv8M9X9OeOD3k7TXLVk+TDP4Fd9lRFBvSkQ44VA5X
         HVhGyJjy08nyNZ8T9gg8P/bj6jgaM569voicSAXScW7Gmx+YXC1qDJbnqAPVvA9yjoct
         UhBRK1iGD1K/p5Wwx7+GeDYq1P5SMo5vYCd8EAuRlvhxb4skRQCI6SANEaNQwFVMcGbz
         JYLrHGHpAeUgS9WS+2o10/44xdYjnDNnjFZimsvX1BNdcRABfmiaimQ8zpdoX6hN86Bl
         0IWQ==
Content-Disposition: inline
In-Reply-To: <20170816185241.GF4087514@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Fri, Aug 11, 2017 at 09:37:51AM -0700, Tejun Heo wrote:
> > This patchset implement cgroup2 basic resource accounting and track
> > CPU usages on all cgroups by default.
> 
> Ping.  I've renamed as Waiman suggested.  If there's no further
> objection, how should we route these patches and the following cpu
> cgroup2 interface patch?

Please hold off on applying it before PeterZ gets back from vacation and has had a 
chance to review it.

Thanks,

	Ingo
