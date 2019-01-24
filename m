From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] mm: Create mem_cgroup_from_seq
Date: Thu, 24 Jan 2019 16:04:49 -0500
Message-ID: <20190124210449.GA14136@cmpxchg.org>
References: <20190124194050.GA31341@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=On+Ju2/jG/TvajQP/wDisjpcbshjNNlG5MNkLQVn1Nk=;
        b=dKMD2NmbO5prZaNx2YHoPu2Hmaa+Hi+8SXHBi9aLBU6rJpU4N1Y0Gr3NycZAJALkAY
         zS2f3R6QFXE36JxGApdfRH4tIGW8VwFRUZLJe8pvmAU8u2WaIzJHOf5pKefG9cLHd+A9
         Z+KjGJqf3zbaYFr4dpsoRnXaf8oFWzbJ+RNVa7D+4AF/aIve8sYIVe81/5RigHbiA8IU
         xbsA9Okfw3if8dRvVvUfSgbTiANPa1nCm4qks1lv9ghBohqHmTB+wT2ZQSCZTFjsVyJx
         cC6PuQ68Y+cNr4syjsJ2OoqZ2KTH9X+lNGmiXIOEDjHQpUs09L3tISJCkalB+rZ751Pc
         Z+sQ==
Content-Disposition: inline
In-Reply-To: <20190124194050.GA31341@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Thu, Jan 24, 2019 at 02:40:50PM -0500, Chris Down wrote:
> This is the start of a series of patches similar to my earlier
> DEFINE_MEMCG_MAX_OR_VAL work, but with less Macro Magic(tm).
> 
> There are a bunch of places we go from seq_file to mem_cgroup, which
> currently requires manually getting the css, then getting the mem_cgroup
> from the css. It's in enough places now that having mem_cgroup_from_seq
> makes sense (and also makes the next patch a bit nicer).
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
