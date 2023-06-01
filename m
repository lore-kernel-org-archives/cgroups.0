From: Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v4 4/4] sock: Remove redundant cond of memcg pressure
Date: Thu, 01 Jun 2023 11:10:32 +0200
Message-ID: <db32243e6cb70798edcf33a9d5c82a8c7ba556e2.camel@redhat.com>
References: <20230530114011.13368-1-wuyun.abel@bytedance.com>
	 <20230530114011.13368-5-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev+bounces-7041-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685610644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g14oLQSgEmt6zzVDTbcm+P3Q+U0P9qW/qGUNJAVuUPE=;
	b=Ml3NHHTqF0YjUWT36sDC61n0gBIT+lvd6FixJbHoBTHNfRqsExJTXgT5kkS/zUd4CAge+s
	HI5uCi9YxT0ZBZPa0k0FJ5ceJJLFNm/t9RbFsytWEa+Z8yT8cVWBatMOWL7t/AWflNIdVj
	pGLPES6hS/XDDgOcIRQmT8DckRLAWn4=
In-Reply-To: <20230530114011.13368-5-wuyun.abel@bytedance.com>
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Abel Wu <wuyun.abel@bytedance.com>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2023-05-30 at 19:40 +0800, Abel Wu wrote:
> Now with the previous patch, __sk_mem_raise_allocated() considers
> the memory pressure of both global and the socket's memcg on a func-
> wide level,=C2=A0

Since the "previous patch" (aka "sock: Consider memcg pressure when
raising sockmem") has been dropped in this series revision, I guess
this patch should be dropped, too?

Is this targeting the 'net-next' tree or the 'net' one? please specify
the target tree into the subj line. I think we could consider net-next
for this series, given the IMHO not trivial implications.

Cheers,

Paolo


