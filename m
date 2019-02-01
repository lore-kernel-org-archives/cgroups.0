From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: memcontrol: Expose THP events on a per-memcg basis
Date: Thu, 31 Jan 2019 21:58:43 -0500
Message-ID: <20190201025843.GA19018@chrisdown.name>
References: <20190129205852.GA7310@chrisdown.name>
 <201902011021.dwu1fKhG%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eKzGGb5J7xnw7YW9klEzISreEEiI8ajXRNdS4HRdGss=;
        b=WUybDOPT0Ir6GsF67zeiTl4e+obVjnbqnKajN9ynkx2TUorRE78G8h797zfEC4US+o
         CyZXCuPyzEgTAheG4maLrlxAuTZCu1z2E3z220ChhxSM1dtGqkTfBTZYynVXZqRV42h6
         nSvYYRKIdNgkukoPBcM9JvKPZ+5PuUv7qM/vM=
Content-Disposition: inline
In-Reply-To: <201902011021.dwu1fKhG%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

kbuild test robot writes:
>Thank you for the patch! Yet something to improve:
>
>[auto build test ERROR on linus/master]
>[also build test ERROR on v5.0-rc4]

This was already fixed and is now in linux-next.
