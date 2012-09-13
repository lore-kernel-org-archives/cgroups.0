From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Date: Thu, 13 Sep 2012 10:52:16 -0700
Message-ID: <20120913175216.GB7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120913121629.GL7767@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zEZKVZ4boCNZvLwj9T1V4IY/d8fYfS00B4G6XwXJDuc=;
        b=mZQJBg1cmStKTl+obj1zlTexxqmvj4K1sdTQKprXTG9k53AwkAzm/CXbbuwl60Z61J
         TWnC1FbuFeoumEUDMCG8JYKCuyGvQKA7N3Vx4qBr2IyWdPU3lI6UPgK8I2vmKACiyNFe
         I5TvMDEufqGeZ70PBxqKqC4cjgDDt4Kch3gG1VkL6BBrXitrqPPiLOf8OAjvv8B+UwZu
         c5bN8gjzehQHTHvbrMshAAbdGU9sLfAaih05UWttlZ9CC0igfjdaHYLES5I77CUXVB0D
         4QY6b0czwjtcU4itxe7RO7+zS5xrqaxwD7pu4Wvc0Iv2lBETBjzVpcbo4+aPdBmOE22Z
         FWOw==
Content-Disposition: inline
In-Reply-To: <20120913121629.GL7767-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Daniel.

On Thu, Sep 13, 2012 at 01:16:29PM +0100, Daniel P. Berrange wrote:
> If you want application developers / users to understand this, then
> you really need to update the Documentation/cgroups/cgroups.txt file
> to provide suitable recommendations on use of hierarchies. As it
> stands today it arguably encourages apps to make use of arbitrary
> hierarchies. While some of the other docs (blkio-controller.txt) do
> describe the limitations of their implementation, they don't ever
> go as far as recommending against usage of hierarchies, which is
> what you seem to be saying.
>
> Just printing warning messages in the logs with no docs to explain
> the issues which cause the warnings is not friendly to users, and
> IMHO will just lead people to ignore the warnings.

Oh yeah, we definitely need to update the docs.  No doubt about it.
Will do.

Thanks.

-- 
tejun
