From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v13 05/16] vmscan: move call to shrink_slab() to shrink_zones()
Date: Tue, 10 Dec 2013 12:10:34 +0400
Message-ID: <CAA6-i6oO71Ja3z4dAsawTmsNm_FkzmU-LWvq70X+X9JTMDSSiA@mail.gmail.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
	<71c7c5bbcad2e29f81eaf9eaad36c120815125c8.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=eiYUzfq42g/6/deAVvO/BN//Og3VS5Pe2JRILvw3ndU=;
        b=OJeP3R3zV52kCgXhED8IetDaSvSBjxENX/53f0uZGR9WY9Qlwt3GRLztP0aQwAqr+u
         w0gCUR1CiWLtt3VtQsf2enaW51r22v4/3DGoNBRp2mDtbOYCKzGyKzOxYB9D2H54oTvH
         JUvKWl/Tqfx/wr8QvFn1GyhYhnwVWVS/M8+fk8NMQQBMrChIT9XXHpWQqYTRZHZXKYrt
         ybs/LjfmbolgZUK/OKULDOIwWITeKll2m9K34QNay5ROv+97IubUITnR48rNtTOfNKb5
         WSLOwTj22c7eoD2WqUeKGFC10OrWOVfhk7EjLIhFxEwm2nFeVgrXqN8wpc7pORs4SVFm
         sAEQ==
In-Reply-To: <71c7c5bbcad2e29f81eaf9eaad36c120815125c8.1386571280.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Glauber Costa <glommer@openvz.org>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>

On Mon, Dec 9, 2013 at 12:05 PM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> This reduces the indentation level of do_try_to_free_pages() and removes
> extra loop over all eligible zones counting the number of on-LRU pages.
>

Looks correct to me.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
