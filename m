Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442486;
	b=EnSaCy6+DAnlI9mCWUzof2EmQDJ5kdGo3vgfpYOP51r2aqSkvDz161mwPXa634RYLToK
	 1x6D2qOB5KgAR8Jgctjy2g9OUTfauTYwNf4TuXU3rZejSbHbItIXR1EiCi9Jh0bEvVW3v
	 6OAyYsTQr6Ux+Vdsn81jBsIqVen/9Jj6Ckw8s9eRD1828UwIB/3hrtmASznN888C5eDYq
	 C75DGX6pr0TfakoCKkifl7dZDGIzxwQ3ZiJyzKAjzS5QY8OLLsZ5BWxmt1t3hl1HBVvAt
	 e/z6S416SUXXref9/C2t0fhzHArtfLozRfLefWMzCTmcVGhj01fXev76hnsX8crQsog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442486;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=vG8DGIHiY7DMGeo+eA0u14jrv8r12vq2uH5/qp0e+4w=;
	b=1W7S+niMl4FpuN7o39AUnWpIX6+tV6b1eiarghwtaxAF3xKm5Xbh7TNm1xpKwatJcDKD
	 bZEDQFbzFr7zFIvq3v/5xwexnc0QVPESQB9TjN1X8+RL/lqZYhDidkF4wpR1oe/bunoyy
	 ASPDgcD0kryc1t30bgr93Ixv8vhhrfSLLwpoz1tIl2ZdLTj5mqc6weoHcxY/3lZ4g82hU
	 m3Pzo9UqM1G2HOrltNWFRrWkbo7b4TYsOROAH2OrJMo3MBdGL59X4LMWQUxpNL0hn5QOO
	 2XkOVPSjxjHYe3K3+V+SGrylwdeX9+R9PSp9aaMN/kuYu1mnrDs+yBO9C5JKtuNURnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=HvoqpFfv;
	arc=none smtp.remote-ip=209.85.160.180
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB03A606A31A
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 14:01:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB03A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=HvoqpFfv
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5495d549924so38072241cf.1
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 06:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795442485; x=1796047285; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vG8DGIHiY7DMGeo+eA0u14jrv8r12vq2uH5/qp0e+4w=;
        b=HvoqpFfvQJEyD7yCLKdxLSgIAzaLXp3MuIOJlQD/xTNp3eiDg6Ra/gTk2UwtMg8a7r
         51Fdi8rwbAEzrbgpfyQRcX6ocwx3JbZqs3lMtg+oSCOxztbX4sMSEqwzwBMMXIZhbH2z
         +cWKiZlrDbUnOjK2Dc/xmxc6lhEP7P0zCv9fK8Q6R+LbGf8sSkVAJ3VI047utN/3Xvv4
         E+aRxCbXLC4Q26EJEfMDphlos6jB6B2Elx2CW7JhFNTETwNm4m8/cfY28pwtDbaTGmPb
         vBtJ7fUBmY372UX/XLhDP7oxTPwPWEyn4GbQKKsOdOJ00EB3fq5g2EwkvonKgUxXTVD5
         DPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442485; x=1796047285;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vG8DGIHiY7DMGeo+eA0u14jrv8r12vq2uH5/qp0e+4w=;
        b=Xz/6Pfmwl7DP5/ly9Tr84WZbqVnV1/FDTcvnvfB1iE4uOgcpfmkdYkO4csjcu5gdDV
         TgYuyIA+3zBV7g8zrM31beI2WcTVRFk8uQnbXnhP8G5rVuctdqCo2zzC3TVjYeg/ttia
         nB6unX5uZBzXCXRriJfLiaOSFN8lVgsoDmp6d1KKer9OFAVMsJkX9EtgjBjFQ+4WX2TN
         Np6D2XG21pjl6spzgXUhIM6UawnBuGdcQoZ5iqSH5+ZkvxA1Ob9QCIQWCd3oCJ49CSJA
         fLjhq78uQoHXObO6stN01g0Mo7kZzf+Qqoc3KkmCKBDkmGAk/hv2kWGqg8GpBNOTQUYB
         /77Q==
X-Forwarded-Encrypted: i=1; AL+hErEbaZYzYP+daatJB2LZYVVtjlr3OlI649qYOnECThMjP96n9Z+i8qy7JRO3sU4TyXebejkOEfkz@vger.kernel.org
X-Gm-Message-State: APuU4Z/gKPUkZqX5j9Dfc7jZLAp6pDgMM+7LOt6eECWQIl4wkuoJpCXd
	JrmefnyJgNh+1xWuL7nL+LjL7dK83mzCAcKaFzfx2HIxe+PxMMf5xhEMI5hBa/FBu40=
X-Gm-Gg: AZFdTZcvAC5nJaHFhiwkJji6cuWx76iJVDDVP9qiVgu6jzugPRzbFZsdR139GNmnlQu
	MbPwOp9HFjgWwFCNPbvXCCyR76WadgTwV5i0fHq6CjcWYsmf8lx1knb+HQFeXaOUuf6Sv5+LVGT
	lDE8/cU8/YV0/fKHJuqZeJWEAJm7D1PD14wblP9HUY00BnakHLaBGVzPBSJVwFnLhkjvs88s2/b
	7VP3KdL84XUIHjp0bBE8lBGKHRsi02vIcFTtmbtFYinoqj0GZn2fNWhBYgpBK7EpjFDtc3sauVc
	Id6f8C7JJBNM5nHboqOCSM/JUCSwHUuK7kZEezN4BWmsfs8WqE0VuoLm7BFj+8oAN9RrBmoUoSP
	xigxIoLlyoN82iwjJ18zkA/VloWZMQOIYUlNPOKM0Ks8xcU91z/h9X7zDJhKC5RLWtjT6facXl3
	doOKjl+TTiFigbTRh9mVWqGxVijaplnWQLg993EjDEjEYBne0/azGW6/B6wy6CfbfRQXQjRlAo4
	5PIT0Zxf4iAELQBQ0dzG93M3oJFswFYLg0wJh7G9/YPGSK5DfPUw3CwN+aZZvGYd5daqJRIAiqt
	8QIlRiVg7Hzi6u8mV1XIgn73VnxHzy9uNH7lY5xaK6DcxvjaSKeJDkYpn4TdWmxjjmqn9DSF4pI
	jW6gEbKk=
X-Received: by 2002:a05:622a:8413:10b0:55d:8475:aafb with SMTP id d75a77b69052e-55d8475ad43mr113506371cf.71.1795442484804;
        Mon, 23 Nov 2026 06:01:24 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788074desm99999281cf.7.2026.11.23.06.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:01:24 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/60] nodemask: add node-state iterators
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: gourry@gourry.net, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
In-Reply-To: <awMK9V6TbU9Xtzn9@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
 <awMK9V6TbU9Xtzn9@yury>
Date: Mon, 23 Nov 2026 09:01:22 -0500
Message-Id: <179544248227.412063.16491857533875192357.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-22 10:32 -0500, Yury Norov wrote:
> On Fri, Nov 20, 2026 at 01:08:52PM -0500, Gregory Price via B4 Relay wrote:
> > From: "Gregory Price (Meta)" <gourry@gourry.net>
> > 
> > Add first_node_state() and next_node_state(), so callers can walk any
> > node state the way first_memory_node and next_memory_node walk N_MEMORY.
> > 
> > Add for_each_node_mask_state(), which iterates a nodemask intersected
> > with a node state using the bitmap intersection helpers, without a
> > temporary nodemask.
> > 
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> >  include/linux/nodemask.h | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> > index 607373bd83ee..90bdcffa42ea 100644
> > --- a/include/linux/nodemask.h
> > +++ b/include/linux/nodemask.h
> > @@ -411,6 +411,11 @@ enum node_states {
> >  
> >  extern nodemask_t node_states[NR_NODE_STATES];
> >  
> > +/* Iterate the nodes in a mask that also belong to the specified state. */
> > +#define for_each_node_mask_state(node, mask, state)			\
> 
> for_each_node_state_and? We've got for_each_node(), and we've got
> for_each_node_state(), so let's figure out consistent naming.
> 
> Did you check the codebase for exsisting candidates for this helper?
> 

for_each_node_mask_and() would be more consistent, change just requires
passing node_state[N_MEMORY_X] instead of just the node state bit.

> > +	for_each_and_bit(node, nodes_addr(mask),			\
> > +			 nodes_addr(node_states[state]), MAX_NUMNODES)
> > +
> 
> Please use nr_node_ids instead of MAX_NUMNODES.
> 

I followed for_each_node_mask() which uses MAX_NUMANODES but let me
look.

> >  #if MAX_NUMNODES > 1
> >  static __always_inline int node_state(int node, enum node_states state)
> >  {
> > @@ -435,6 +440,12 @@ static __always_inline int num_node_state(enum node_states state)
> >  #define for_each_node_state(__node, __state) \
> >  	for_each_node_mask((__node), node_states[__state])
> >  
> > +#define first_node_state(state)	first_node(node_states[state])
> > +static __always_inline unsigned int next_node_state(int nid, enum node_states state)
> > +{
> > +	return next_node(nid, node_states[state]);
> > +}
> 
> At least the following {first,next}_{online,memory}_node must be
> switched to the new helpers. Can you check through the rest of the
> kernel to make sure all candidates of the proposed helpers are
> converted?
> 

I originally intended to delete first/next_memory_node, to make
usage of N_MEMORY a bit more obviously, but dropped it to save an
extra patch or two.  I will probably add that back in.

But yeah i can update these otherwise.

-- 
~Gregory

