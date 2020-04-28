From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm, memcg: Decouple e{low,min} state mutations from
 protection checks
Date: Tue, 28 Apr 2020 17:19:53 -0400
Message-ID: <20200428211953.GB400178@cmpxchg.org>
References: <cover.1588092152.git.chris@chrisdown.name>
 <51ffacb736bb02ecc09c828ebe8f4ec7fda68c48.1588092152.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DYMJh06e9iMMWdrsr02cndKE1zO1nSUZw6qGhVvzfJk=;
        b=Y04B/etyyvTEoyxiFp/Ge/tIuXV13XVK0tWT0wMgXagiNpdXZHu671Z6uz1oRQxTB/
         luDeG+Ku00p2UIdq6iTHAj9wPCunMVfBBb7rEmmQQoPJMnvNJbx9jNYKKvrwAxUM2POw
         NsPtGsFu+ENVdOtc0jqhTayn09DQb7BFMworUt92vQxYGwMip2kjIPcUtpO8P2SSG4Sb
         ipW+OfYq3uk7IwQhZ4zZTN20uXB8GtEQZsq8l1ttW9kaZJd9zkSybkcacHxlcVU7vCFm
         dGy41fvebrFw1PFFAc8HjEB30V0SWwU7SSLDh0nH1vGdWM2eUPfMopufnc0w0Wl3xMiG
         mujQ==
Content-Disposition: inline
In-Reply-To: <51ffacb736bb02ecc09c828ebe8f4ec7fda68c48.1588092152.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 28, 2020 at 07:27:00PM +0100, Chris Down wrote:
> mem_cgroup_protected currently is both used to set effective low and min
> and return a mem_cgroup_protection based on the result. As a user, this
> can be a little unexpected: it appears to be a simple predicate
> function, if not for the big warning in the comment above about the
> order in which it must be executed.
> 
> This change makes it so that we separate the state mutations from the
> actual protection checks, which makes it more obvious where we need to
> be careful mutating internal state, and where we are simply checking and
> don't need to worry about that.
> 
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
