From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 1/2] ss: introduce cgroup2 cache and helper
 functions
Date: Tue, 5 May 2020 09:42:13 -0600
Message-ID: <7edb94ab-badb-e2f5-42fc-f04d38d29791@gmail.com>
References: <20200430155245.83364-1-zeil@yandex-team.ru>
 <20200430155245.83364-2-zeil@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OdSiaVzqGpXkKErkBltChUbo57smog+mPGXXST7mpwE=;
        b=swOHeOWR+HuU6TtVziCADaRF6lOWBfKvUpUX8SVljvZscu1Iz4LWJEZNcUdU9+cjIo
         WGjooglq64KqR0LMuLqXbZlaVO0oqb9oEZNJok4mBm7CtcG4YI4KDq0vHslEFi/ZAyb9
         8ij98N+MzWxd9N5Iwgi9cbUBr3ErTo8StfSvrSJ7Lx1ItCjO3+dLF4Jie5eGLEZ6uafD
         2BEirE8E9hyHYFrtmuhamxMUqyYbUNpWtJr1pxMaznzCpHVKheb+MFVKn5Y7eHigvybY
         xblDiVnKGSO1YOVZCBOhDyivCijimZrtwgQUMs6QzuaU2V0EFW5hbL22ycsa7Hc27KUL
         dPuQ==
In-Reply-To: <20200430155245.83364-2-zeil@yandex-team.ru>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dmitry Yakunin <zeil@yandex-team.ru>, netdev@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, cgroups@vger.kernel.org, bpf@vger.kernel.org

global comment. iproute2 uses the net coding style of reverse xmas tree
for declarations. There are a number of places that need to be fixed up.

On 4/30/20 9:52 AM, Dmitry Yakunin wrote:
> diff --git a/lib/cg_map.c b/lib/cg_map.c
> new file mode 100644
> index 0000000..0a1d834
> --- /dev/null
> +++ b/lib/cg_map.c
> @@ -0,0 +1,133 @@
> +/*
> + * cg_map.c	cgroup v2 cache
> + *
> + *		This program is free software; you can redistribute it and/or
> + *		modify it under the terms of the GNU General Public License
> + *		as published by the Free Software Foundation; either version
> + *		2 of the License, or (at your option) any later version.

Drop the boilerplate in favor of SPDX line

> + *
> + * Authors:	Dmitry Yakunin <zeil@yandex-team.ru>
> + */
> +
> +#include <stdlib.h>
> +#include <string.h>
> +#include <stdio.h>
> +#include <stdbool.h>
> +#include <linux/types.h>
> +#include <linux/limits.h>
> +#include <ftw.h>
> +
> +#include "cg_map.h"
> +#include "list.h"
> +#include "utils.h"
> +
> +struct cg_cache {
> +	struct hlist_node id_hash;
> +	__u64	id;
> +	char	path[];
> +};
> +
> +#define IDMAP_SIZE	1024
> +static struct hlist_head id_head[IDMAP_SIZE];
> +
> +static struct cg_cache *cg_get_by_id(__u64 id)
> +{
> +	struct hlist_node *n;
> +	unsigned int h = id & (IDMAP_SIZE - 1);
> +
> +	hlist_for_each(n, &id_head[h]) {
> +		struct cg_cache *cg
> +			= container_of(n, struct cg_cache, id_hash);

Don't split the line like that. Since you need 2 lines just do:
+		struct cg_cache *cg;
+
+		cg = container_of(n, struct cg_cache, id_hash);

> +		if (cg->id == id)
> +			return cg;
> +	}
> +
> +	return NULL;
> +}
> +




