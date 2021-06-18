From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/6] sched,timer: Use __set_current_state()
Date: Fri, 18 Jun 2021 22:42:38 +0200
Message-ID: <87sg1eewg1.ffs@nanos.tec.linutronix.de>
References: <20210602131225.336600299@infradead.org> <20210602133040.524487671@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624048959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=viaF2+vzF8yGuceHiGdcXmR+KhaApSpPdBORO7fsb08=;
        b=ezsxCMn96b+2rHdzRATVpDVBpAYMddpcAvBC98rFOdITrLchNFKuyjWGTqiD/peJdjfyZo
        9uA2SACZ7MDy7RW/rBDSPjsl2GGYfeESMBAKGPmDMR4ZLxDMQmS9JRSgoiTdHgKzEYCA7D
        0fAwkVCTrOBU59v1jzl5McNQQNJ3p/rhehvTGnWJEzlHBUzdoN7aS303gjP3spWP7G5SWh
        ok/HPjFbxtVYnv1cMLG8UEqBdXEujEWCyqYYoB7pWpTPWqBlc8VdE/cR1EqGjaCBnteb3s
        iVmZgxZGlmKicLxoqfVSOyzZNaJs/Rs1Ug91LJmtPT/PUyTsAQAPvUaoSq+7Vw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624048959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=viaF2+vzF8yGuceHiGdcXmR+KhaApSpPdBORO7fsb08=;
        b=vMq4tRHu7ixDGl3mtG0JpRgtNMAsZHXhoKJUnNyvBYVWnj1SLFxNFsZoD5kQMCDWRCTerB
        6JPjgWDDW4WzKbBQ==
In-Reply-To: <20210602133040.524487671@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jason Wessel <jason.wessel@windriver.com>, Daniel Thompson <daniel.thompson@linaro.org>, Douglas Anderson <dianders@chromium.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>

On Wed, Jun 02 2021 at 15:12, Peter Zijlstra wrote:
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

