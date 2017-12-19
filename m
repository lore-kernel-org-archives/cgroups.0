From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Tue, 19 Dec 2017 09:33:54 -0800
Message-ID: <20171219173354.GQ3919388@devbig577.frc2.facebook.com>
References: <20171219000131.149170-1-shakeelb@google.com>
 <20171219124908.GS2787@dhcp22.suse.cz>
 <CALvZod5jU9vPoJaf44TVT0_HQpEESiELJU5MD_DDRbcOkPNQbg@mail.gmail.com>
 <20171219152444.GP3919388@devbig577.frc2.facebook.com>
 <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VgqPf1dFPXDAbwBnEMiUKfuhUcN5YQyQv5wPwdrIWss=;
        b=tdBF0EChoN8FVPeYAp97UvwWeiTE0XwoldriUFF+SYdLx1J8HXeaMU5IcBxZGzxTdn
         98BVe8qoHVal91T8GuRietWTF5mPGKxgy/9FxiFEUPc7ZeOV+eo9W5ung1v9c16mhSAO
         ytg+D411mBOoUHNgGGC1vxIVlMi+xJfJjQcWFy1QwNVZt1lAEzn1B2FQ4jvKrg1QY0yI
         vVas5l1TX+tlXUIb11k3+KqQ7SMR8X2DPHNfp+uct99nt6VrK+nID1JnpIMhIeREXoba
         B9dIUf0GeCHE6sOuzBCiM8IhoCOEv6y1j46tNjBVozriGArntY3F+EcCuZ9HFhvSeJFL
         NFlQ==
Content-Disposition: inline
In-Reply-To: <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Li Zefan <lizefan@huawei.com>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org

Hello,

On Tue, Dec 19, 2017 at 09:23:29AM -0800, Shakeel Butt wrote:
> To provide consistent memory usage history using the current
> cgroup-v2's 'swap' interface, an additional metric expressing the
> intersection of memory and swap has to be exposed. Basically memsw is
> the union of memory and swap. So, if that additional metric can be

Exposing anonymous pages with swap backing sounds pretty trivial.

> used to find the union. However for consistent memory limit
> enforcement, I don't think there is an easy way to use current 'swap'
> interface.

Can you please go into details on why this is important?  I get that
you can't do it as easily w/o memsw but I don't understand why this is
a critical feature.  Why is that?

Thanks.

-- 
tejun
