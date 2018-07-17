From: Daniel Drake <drake@endlessm.com>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory, and
 IO v2
Date: Tue, 17 Jul 2018 07:13:52 -0500
Message-ID: <CAD8Lp45W00ga-P-nb6iytgSGW4xwSzmaTHA87DOvSotN0S2edw@mail.gmail.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org> <20180716155745.10368-1-drake@endlessm.com>
 <20180717112515.GE7193@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=RFSxLmV5XRvk6onU0K53XB6cLUvMH5u79t53P9Dy/Eo=;
        b=Hn/vgjdwQ197IABewW6nhn0MEvTvwSPWR1dWb5zfGjKiYusfmy6Xa1+Gp/hvpi2OpB
         v3afJDJLv8k6jWdzt1A9GPwKm6vbbbDjajMz4G+XncsRqkbhBmvCgD8A5qVIBoX4s1zH
         9+vFIZHogZGCJUoNO8uyehBfO/ckOlLBwVT/g7YQpAJYETVvKLeh7YxvK0q/BMVbtw7D
         mmJsj1/Z25f6MR0U65F0Pq4dGe4yXz7cvkqnyRYBedL4I+9ptUoZ1hsQoDtEASISOqye
         v2Tix9mXAR+lxz8tSixWk3ze04XodMSYdOZLSN9oORZMGKDmLt8U9z74x6M0qOrCNW7z
         a0QA==
In-Reply-To: <20180717112515.GE7193@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: hannes@cmpxchg.org, Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, Linux Upstreaming Team <linux@endlessm.com>, linux-block@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Tue, Jul 17, 2018 at 6:25 AM, Michal Hocko <mhocko@kernel.org> wrote:
> Yes this is really unfortunate. One thing that could help would be to
> consider a trashing level during the reclaim (get_scan_count) to simply
> forget about LRUs which are constantly refaulting pages back. We already
> have the infrastructure for that. We just need to plumb it in.

Can you go into a bit more detail about that infrastructure and how we
might detect which pages are being constantly refaulted? I'm
interested in spending a few hours on this topic to see if I can come
up with anything.

Thanks
Daniel
