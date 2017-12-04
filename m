From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 4 Dec 2017 14:58:25 -0800
Message-ID: <20171204225825.GP2421075@devbig577.frc2.facebook.com>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xpYpZH84sUfKg9L7c65FK1k63nXQaEIIXUOH9VpnO9k=;
        b=ceqXhievl57EoYo/A1xEd5Av0kj+EMO8YTd4GnZW65WfCKOfKmh14RgoB3bNUHRGxE
         YDC2LiDSe85o10ZLMeHdQ2nJ31O3oqUHuZ0e3klYVGiZWfmHPNw5H4Lw+dEik7i8J6VL
         +BtDheRRofo75KOFVqUUAS/Qcik9wqEqtylaZyJqGeJ/WXnPZ7muUMD8vGFVij5QsJbr
         HLMs0as7ALRd95JfJL2TWzt51L9/RTxEMvBxquJvxr0NCyt9OND0bAplU+seXBvQKkqy
         pOiPVkrQG4sUFfGYyRs5U8hvzjJ44j57WWJLdD+xTRuTcgDuua2ALPr1Lr173/oybI5N
         7xqQ==
Content-Disposition: inline
In-Reply-To: <20171204202219.GF2421075@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: avagin@gmail.com, mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

Hello, again.

On Mon, Dec 04, 2017 at 12:22:19PM -0800, Tejun Heo wrote:
> Hello,
> 
> On Mon, Dec 04, 2017 at 10:44:49AM +0530, Prateek Sood wrote:
> > Any feedback/suggestion for this patch?
> 
> Sorry about the delay.  I'm a bit worried because it feels like we're
> chasing a squirrel.  I'll think through the recent changes and this
> one and get back to you.

Can you please take a look at the following pending commit?

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/commit/?h=for-4.15-fixes&id=e8b3f8db7aad99fcc5234fc5b89984ff6620de3d

AFAICS, this should remove the circular dependency you originally
reported.  I'll revert the two cpuset commits for now.

Thanks.

-- 
tejun
