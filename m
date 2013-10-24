From: Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 2/3] memcg, kmem: rename cache_from_memcg to cache_from_memcg_idx
Date: Thu, 24 Oct 2013 20:31:04 +0300
Message-ID: <52695958.50004@iki.fi>
References: <1382527875-10112-1-git-send-email-h.huangqiang@huawei.com> <1382527875-10112-3-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:date:from:mime-version:to:cc
	:subject:references:in-reply-to:content-type
	:content-transfer-encoding; s=smtpout; bh=sEKpuJ02ZGEP3o0074VBDo
	7Dr1A=; b=rCzGbhIvKQwjCctm1KJJnzS2IP7ebr5W16Vpk4w0r9yJVTGi3hzo9w
	VDipliD+N5yh7gx93SAt4I+2aD+GWAPjgsOL3Ot5l4zTS2kkh+T/8XFI7NDfVY+0
	vQPLY2rNqMxhjqXE0wa+CmRRCov/ZyAXVyt6kVzkpmA3Lid81SNE8=
In-Reply-To: <1382527875-10112-3-git-send-email-h.huangqiang@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Qiang Huang <h.huangqiang@huawei.com>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, mhocko@suse.cz, cl@linux-foundation.org, penberg@kernel.org, glommer@parallels.com, rientjes@google.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

On 10/23/2013 02:31 PM, Qiang Huang wrote:
> We can't see the relationship with memcg from the parameters,
> so the name with memcg_idx would be more reasonable.
>
> Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
