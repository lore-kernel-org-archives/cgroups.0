From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] oom_kill: add option to disable dump_stack()
Date: Wed, 28 Oct 2015 16:55:31 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1510281655010.15960@chino.kir.corp.google.com>
References: <1445634150-27992-1-git-send-email-arozansk@redhat.com> <20151026172012.GC9779@dhcp22.suse.cz> <20151026174048.GP15046@redhat.com> <20151027080920.GA9891@dhcp22.suse.cz> <20151027154341.GA14722@redhat.com> <20151027162047.GK9891@dhcp22.suse.cz>
 <20151027175140.GC14722@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=ekMQd3S51MkgpdBSHS77EN7WG6eOqtdmqMuUd0u7waw=;
        b=gzLgNJMUBWPaBHZNFm27/jBbhqE4syv4gS3njDUN91RRawIr01eQAhNWkCOIoumh+X
         hcoq5MfHpZW7vTISAM/h3ik4HCtrqZakG2nBHH7kh2BuGWTg20qIBIsyJEDuYRdQtRhi
         pStSUlzHy24uV47GS/vp/5isxZwgGawiFwZbyQhc1rZZNN8PnGxppCWvnCiywR3SRGVP
         VcHF6UeD4XGvz80XXnPSQuWFT4YaYLoVaKDOrP6dJIQThnJNN+7ufho0ZwUdsFV/TkS1
         wjLS9h7LJPWnRp39kOJSv937maZ+sjC3PZSs9mMpYE9/9PCuwhvetyizbg0LVjrbb30N
         3/RA==
In-Reply-To: <20151027175140.GC14722@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <arozansk@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, cgroups@vger.kernel.org

On Tue, 27 Oct 2015, Aristeu Rozanski wrote:

> Hi Michal,
> On Tue, Oct 27, 2015 at 05:20:47PM +0100, Michal Hocko wrote:
> > Yes this is a mess. But I think it is worth cleaning up.
> > dump_stack_print_info (arch independent) has a log level parameter.
> > show_stack_log_lvl (x86) has a loglevel parameter which is unused.
> > 
> > I haven't checked other architectures but the transition doesn't have to
> > be all at once I guess.
> 
> Ok, will keep working on it then.
> 

No objection on changing the loglevel of the stack trace from the oom 
killer and the bonus is that we can avoid yet another tunable, yay!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
