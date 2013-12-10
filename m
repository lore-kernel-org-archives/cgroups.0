From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v13 04/16] memcg: move memcg_caches_array_size() function
Date: Tue, 10 Dec 2013 12:04:23 +0400
Message-ID: <CAA6-i6oESDwswkmz9hUT7=v8AE4z4GeTqwqrMzxOyTUtanLB-A@mail.gmail.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
	<efacba489a23b3a87321a02828ed1a5094e5c490.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=5SOLIV6122uxNrPav/o5fl4PXjIWW+L6hdcIgLVyqP4=;
        b=olTw+J08BrftIE+tml+WlnGyblaX9tngTdRI4xgR30bhTMf3aQgR/kPKW30ilBkHKC
         db41dHitGjapBAB7HavmN62XMhfXFvHNYxeRxB/sYW/jgGfb2AwmxacSFzgE/6J1lByZ
         VaXhRxAelTN8o+IPmnxWF4weH6rHPyz2+XkGQVY6J17i48CNeVmjV2UDp/4xiRGSyDmU
         ZO7C+pbYFl2ATc1Lz/ToluWVQqsJf29q4UxBlSldD3gAwItZBxlcV394wiJEkaitD2gV
         SvpemS0KX3d7iFcq/xd4jhZIb5CXLqHJxXufpIKxv/6Yooj2AialXUIPJ+9pNFADkPNp
         72Zw==
In-Reply-To: <efacba489a23b3a87321a02828ed1a5094e5c490.1386571280.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Glauber Costa <glommer@openvz.org>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On Mon, Dec 9, 2013 at 12:05 PM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> I need to move this up a bit, and I am doing in a separate patch just to
> reduce churn in the patch that needs it.
>
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Glauber Costa <glommer@openvz.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
