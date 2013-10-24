From: Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 3/3] memcg, kmem: use cache_from_memcg_idx instead of
 hard code
Date: Thu, 24 Oct 2013 20:31:27 +0300
Message-ID: <5269596F.6090206@iki.fi>
References: <1382527875-10112-1-git-send-email-h.huangqiang@huawei.com> <1382527875-10112-4-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:date:from:mime-version:to:cc
	:subject:references:in-reply-to:content-type
	:content-transfer-encoding; s=smtpout; bh=+X6ykq6E9Qb/n6CgRiHZ+p
	grttY=; b=hG5awppXaeqg6W5XqeB+eTvGD4+I2C5G1RfyoUGFcl9vIrHJYpYN5Q
	lri0i0SGoMLPLTRQQSUi1vmAGp/QUsrSaOs2FxPyqC/Cgf/T8QCtJcSuj1we8npr
	9jHvcT9f1V4ZRX6lc2LscqosKI7oN3Io9WvcLB6+YwbEkWve6+8kY=
In-Reply-To: <1382527875-10112-4-git-send-email-h.huangqiang@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Qiang Huang <h.huangqiang@huawei.com>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, mhocko@suse.cz, cl@linux-foundation.org, penberg@kernel.org, glommer@parallels.com, rientjes@google.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

On 10/23/2013 02:31 PM, Qiang Huang wrote:
> Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
