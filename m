From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/6] sched: Cleanup task_struct::state
Date: Wed, 02 Jun 2021 15:12:25 +0200
Message-ID: <20210602131225.336600299@infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=+0GJIyUeezLFp/ym4/vP+fC11EDSc+9M3QstIcNFnoM=; b=HwUP711Hi7fk/GRlHwhhfYuQB5
        K5vYCOeQPuOhkpRqo74FjxBE7Qmwx8Wj6GWtoLKoGosJHAwdRgo9jNLQy1TmIkJWwpfsGoVcLemhp
        yE/DBMFhvtilIfo4dv1JJaSo/mfYt/uX/LfisWcd+3wnlJLAvfkdTdiO1+HtsYKFPZ/tV6bjzqFeK
        4bo4vY52aoMqPrC7we688zYhvu7+dOw4A1kcJpeVTuCoCOtBGxbR88VN+otXu+yI9l3xV+f66r/TA
        vzFWO4ght7JIQB07yN0JwJ0Lzx83FvV5EUgJ9xU0ODmz2KYDDLO3n44qTW1zqH17jqyBTMXum4Ngk
        tEM+eMIg==;
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jason Wessel <jason.wessel@windriver.com>, Daniel Thompson <daniel.thompson@linaro.org>, Douglas Anderson <dianders@chromium.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>

Hi!

The task_struct::state variable is a bit odd in a number of ways:

 - it's declared 'volatile' (against current practises);
 - it's 'unsigned long' which is a weird size;
 - it's type is inconsistent when used for function arguments.

These patches clean that up by making it consistently 'unsigned int', and
replace (almost) all accesses with READ_ONCE()/WRITE_ONCE(). In order to not
miss any, the variable is renamed, ensuring a missed conversion results in a
compile error.

The first few patches fix a number of pre-existing errors and introduce a few
helpers to make the final conversion less painful.


