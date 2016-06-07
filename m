From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Tue, 7 Jun 2016 14:30:08 -0500
Message-ID: <20160607193008.GA31708@htj.duckdns.org>
References: <1465325475-30593-1-git-send-email-bristot@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s1SS1yCpYJl5TgvmXFK4SEFA7nmZyHvHL6WPJvfHoGY=;
        b=gQ9d5Ds9jnYrzbC5pn9/xUMBAclkMiYG68+0TmiNUdGC8pPo8aZuUlhdIMJ6bBFBqg
         xRkXj3z8xbzbyYVfID/U4MSdflGrMkCY3mHJmc+en3nfPBUPzuILTkNbRW+21xm78F1r
         MUIUzb2emkMbzG4z9mrgPyrOEZzsOYkq3HEIvmQVPdmjP3s6lxMQ1SvxXDA/kidwdJJ5
         IR9vdNd6VAAjqfoUml9WaYwPxxw4ZQlm/CZSKXOK0rJBOtSMpezmSmpHNfX8tx+k4ui4
         Pd98KHNqMDOi0s9sHqDcMVCwbxRFBG80u7hICnM1MvrV4IfEGrqPBCSsGRMBOfXddI/7
         CnJw==
Content-Disposition: inline
In-Reply-To: <1465325475-30593-1-git-send-email-bristot@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>, "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@arm.com>, cgroups@vger.kernel.org

On Tue, Jun 07, 2016 at 03:51:15PM -0300, Daniel Bristot de Oliveira wrote:
> While testing the deadline scheduler + cgroup setup I hit this
> warning.
> 
> [  132.612935] ------------[ cut here ]------------
> [  132.612951] WARNING: CPU: 5 PID: 0 at kernel/softirq.c:150 __local_bh_enable_ip+0x6b/0x80
> [  132.612952] Modules linked in: (a ton of modules...)
> [  132.612981] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 4.7.0-rc2 #2
> [  132.612981] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
> [  132.612982]  0000000000000086 45c8bb5effdd088b ffff88013fd43da0 ffffffff813d229e
> [  132.612984]  0000000000000000 0000000000000000 ffff88013fd43de0 ffffffff810a652b
> [  132.612985]  00000096811387b5 0000000000000200 ffff8800bab29d80 ffff880034c54c00
> [  132.612986] Call Trace:
> [  132.612987]  <IRQ>  [<ffffffff813d229e>] dump_stack+0x63/0x85
> [  132.612994]  [<ffffffff810a652b>] __warn+0xcb/0xf0
> [  132.612997]  [<ffffffff810e76a0>] ? push_dl_task.part.32+0x170/0x170
> [  132.612999]  [<ffffffff810a665d>] warn_slowpath_null+0x1d/0x20
> [  132.613000]  [<ffffffff810aba5b>] __local_bh_enable_ip+0x6b/0x80
> [  132.613008]  [<ffffffff817d6c8a>] _raw_write_unlock_bh+0x1a/0x20
> [  132.613010]  [<ffffffff817d6c9e>] _raw_spin_unlock_bh+0xe/0x10
> [  132.613015]  [<ffffffff811388ac>] put_css_set+0x5c/0x60
> [  132.613016]  [<ffffffff8113dc7f>] cgroup_free+0x7f/0xa0
> [  132.613017]  [<ffffffff810a3912>] __put_task_struct+0x42/0x140
> [  132.613018]  [<ffffffff810e776a>] dl_task_timer+0xca/0x250
> [  132.613027]  [<ffffffff810e76a0>] ? push_dl_task.part.32+0x170/0x170
> [  132.613030]  [<ffffffff8111371e>] __hrtimer_run_queues+0xee/0x270
> [  132.613031]  [<ffffffff81113ec8>] hrtimer_interrupt+0xa8/0x190
> [  132.613034]  [<ffffffff81051a58>] local_apic_timer_interrupt+0x38/0x60
> [  132.613035]  [<ffffffff817d9b0d>] smp_apic_timer_interrupt+0x3d/0x50
> [  132.613037]  [<ffffffff817d7c5c>] apic_timer_interrupt+0x8c/0xa0

Is this something in mainline?  This forces all task free path to be
irq-safe, which *could* be fine but it's weird to make cgroup free
path irq-safe for something which isn't in mainline.

Thanks.

-- 
tejun
