From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Fri, 7 Oct 2022 06:42:36 -1000
Message-ID: <Y0BW/GkfXG99+41O@slm.duckdns.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <YyyeSVSk/lWdo/W4@slm.duckdns.org>
 <4b8605533e5deade739249bfb341ab9c06d56a1e.camel@linux.intel.com>
 <YyyykUJQtYbPVctn@slm.duckdns.org>
 <7ff6d114-a6cc-e3c5-5edb-8ac0e527d8a9@intel.com>
 <Yy5KwnRTbFjmKE9X@slm.duckdns.org>
 <0f42e11434b264e555559cab626c1828a9eae09f.camel@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fA1J69IyWYywuIZwnnz1658skPrHk8H2Q+rOTxQzfzE=;
        b=k+qp9uDMOFGiGON2UPmJRKZE/BvPXoOPduPRhrl7Ps84MwHynpX37QTHG9NKD7ypxF
         5eagL9mQsDCbbA2dON00lEtk0HuCuiKHGhtO8qjMaxYv7njE6HVIi7Mc8hmwcFFwcydk
         2vkIMR/gyFZ9HFaKBnDYIe2dKhHQGYlRRnf1WHOmyLr4QzrqPw6hS85oHPAGkGmAa6Zr
         iJ8Nw0mDG5ghKocfk6VMQknNsLHDG+z8D7vxjACLuD6xiDMQEAKg74L/81fp3+jquQuL
         Bfr3H6McidxN+yDJ71R8A7WeKpb7p4ECBq+VUlmSUGlLxm4o1lqSJ8DAuRnYz6Eb0zJN
         Bqjg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0f42e11434b264e555559cab626c1828a9eae09f.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hello, Kristen.

On Fri, Oct 07, 2022 at 09:39:40AM -0700, Kristen Carlson Accardi wrote:
...
> With the misc controller, i haven't been able to find a way to easily
> react to a change in the max value. Am I missing something?

There isn't currently but it should be possible to add per-key notifiers,
right?

Thanks.

-- 
tejun
