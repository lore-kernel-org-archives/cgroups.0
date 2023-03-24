From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] sched/cpuset: Fix DL BW accounting in case
 can_attach() fails
Date: Fri, 24 Mar 2023 15:56:16 +0100
Message-ID: <6dd8bfad-b2d8-1d87-63ed-fd6882a17f6a@arm.com>
References: <20230322135959.1998790-1-dietmar.eggemann@arm.com>
 <ZBwc4l0ZyyRQPiSP@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <ZBwc4l0ZyyRQPiSP-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luca Abeni <luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, Tommaso Cucinotta <tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 23/03/2023 10:33, Juri Lelli wrote:
> Hi,
> 
> On 22/03/23 14:59, Dietmar Eggemann wrote:

[...]

> This makes sense to me. Thanks for working on it!
> 
> Guess I might incorporate these in my (RFC) series and re-post the whole
> lot?

Yes, please do so.
