From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 07 Feb 2023 12:50:24 +1100
Message-ID: <87fsbinsvq.fsf@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
 <Y+Fttp1ozejoSQzl@slm.duckdns.org>
 <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
 <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
 <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <24668a43-fb00-5240-6072-230c5f5d0943@redhat.com>
 <Y+GjSTu9vE/A/EKG@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gACIV1J6Aakw4ZT8mMl+C83X57q5sM9bE/vQSWr9rN8=;
 b=G05K9hYCVW+QPPlvLzVjLnGVv2s8nJOYfjESSkZ0yoz9EL/wAlg60MyZqY3QXW1MkZUNikI7PXH5+6gcujwPktN/NUa3PWti+iGui6JEXUxOWZbzqLcB4PdV1yYdbv0RvsoyyNKeR8EUPgyFFroJvWSJA4CqyiXEa7MY18GD2Q/vLuedowfESRJYkCtqNNhLaK0Yo5qa9HFOHkZvETaxBIVWdsGgCf88YLlLeyYXnkznVdfZfCkXz2xVP/WRPq1lSGWtWFdAbf+l3r9NPqlml8gxAF2TsOpfD0zObonF0hPH03LM5C3CLLGxN+fNaSwZbNrnphnRd9btzraHQAod4A==
In-reply-to: <Y+GjSTu9vE/A/EKG-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> On Mon, Feb 06, 2023 at 08:00:54PM -0500, Waiman Long wrote:
>> If it should not be part of the memcg, does it make sense to make it a
>> resource in the existing misc controller? I believe we don't want a
>> proliferation of new cgroup controllers.
>
> Yeah, if it's gonna be an independent knob, I suppose so, but I really think
> the locked accounting should be tied to the page, which mostly likely would
> mean that it'd be tied to the page ownership too making its natural place
> memcg.

Yes, I think it might be possible. I looked briefly at doing it when
initially developing the series but I would like to resolve the question
of independent knob vs. memcg before heading too far down either path.

> Thanks.

