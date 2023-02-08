From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next 2/5] bpf: use bpf_map_kvcalloc in
 bpf_local_storage
Date: Wed, 8 Feb 2023 14:25:17 -0500
Message-ID: <Y+P3HSLNR94wILP1@cmpxchg.org>
References: <20230205065805.19598-1-laoar.shao@gmail.com>
 <20230205065805.19598-3-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NFlrkeEXgNWehBcAx33U4rHt/JekvgpyEDTdyrAYRpU=;
        b=V22eJSdBMDmC4TCgyxOGFJrfM6rr9USfSzc03bCGt+fb1AGhUkoO4mPupY7BkmUPcW
         9PLRYSREg9TZGrUb4untXaC0WGKlnYuiybeZG6+AEES7ANGcxhPrpvJFhYFt14ySsacP
         zWZXSIDMuEuhKm492fjso5d4Crwy/54yXB4gdinpsDa9rrMoQL+vq94D3qXNLu1kbFqw
         VZx/SG/pw5nT9PyCitWVS+8RXy1V9zlSbsPMp0/njff5Qd+Cx+5MGVA/bbKr8JtgDcNH
         pjKTU/v0/+ZBzy5BZgvnetEVi41tw+lVU8tureVuK6l0DWCCnwmIZeWqP8euzinHhQcq
         kQEA==
Content-Disposition: inline
In-Reply-To: <20230205065805.19598-3-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: tj@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Sun, Feb 05, 2023 at 06:58:02AM +0000, Yafang Shao wrote:
> Introduce new helper bpf_map_kvcalloc() for this memory allocation. Then
> bpf_local_storage will be the same with other map's creation.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

This looks good to me, but it could be helpful to explain the
user-visible part of the bug somewhat, i.e. who is being charged right
now for the allocation if it's not the map owner.
