From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm/memcg: Consolidate mem_cgroup_resize_[memsw]_limit()
 functions.
Date: Tue, 9 Jan 2018 09:10:12 -0800
Message-ID: <CALvZod64eZGKne7jZip_O4_q4yjaRsVWpTRa0pQgRT3guqQkGA@mail.gmail.com>
References: <20171220135329.GS4831@dhcp22.suse.cz> <20180109165815.8329-1-aryabinin@virtuozzo.com>
 <20180109165815.8329-2-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=MmwdIzljGS+jOOoW4u9dWXjqtAZMHbcBL5fwYS2U6GE=;
        b=Ztq+cYoMeWcyW5PbxAhHBXjAHq3wPD0TZDbDTH3LBnPCNX355YISxsU5HF/lee6Gzw
         pcD37xIuHO/1OgjWzc65FjJmoHPptIG9sXPETSjG+ZW93SBHA677HSnnOjgWtp5rBPSY
         zrzz5NnLKvFcWgSJX4eipLF4sqmDAG3OL3KUtwFFKzZ/zxJ+H7Fj58bsU4Yv7dtQwQWt
         mDapRvCsyCaOm9OC4i4DHPI9ECLAuk6DaZa2wl9iQcPQxkpXlC7DOfRrqQzbNcY0GCiq
         ybLSa/A8thzk1Sp3evaTzQ1uvzo9bzHyveqalALZvsI/HJxWh2itwsJhhtQz4ebdZXnN
         EkVQ==
In-Reply-To: <20180109165815.8329-2-aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jan 9, 2018 at 8:58 AM, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() are almost
> identical functions. Instead of having two of them, we could pass an
> additional argument to mem_cgroup_resize_limit() and by using it,
> consolidate all the code in a single function.
>
> Signed-off-by: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

I think this is already proposed and Acked.

https://patchwork.kernel.org/patch/10150719/
