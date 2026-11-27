Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795771599;
	b=Ha+z17zovbKnIf2Mp1E8Wus895T/a0h1awqlWwlg9Uporb8/THYorsxgnaP5WeAcEmhw
	 TfHnFbz9jdO4lwcl+aMwjRTsgh1Z4KfmAJz9sv1U7pE/+E3PsWKbETbDsjMYYeW5CAY+c
	 qMpbCcbfAITB1tAOKZ3ARzjyZ1+v7JrWJ7cVPe5fgJjR5zZWv++w6R46bmjek6j5lEnAH
	 5d/7GQwHyQtAUMuXJB0fQDTiI/+bOAW2nQYn4hb8lnbP6D7fPdftr5PQGl57QkXdd47YI
	 E27Cwh+e46cS/L6D7UDooBTojYluvOaxqMotk8C/zPv7NHlK4v/30AILs2ldBeGJVqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771599;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=hoxVon0gybDyq4RET65wbSko4AYZRSn5g8mIkbvH3EY=;
	b=PqUriPIRwI+mQ18eq3QKz9ybqhKytznYw+sjMFAFVasS64jpUYwD36Qocq7tPzmwPsm7
	 ellSLnL2KVKF7iLY2nzEuyCNVI4tL+vliYHPsmZq9prd+ro49xdOPXv1S0bvx+YQdHbAc
	 YxI1Y0/MKFv/flF1qqzfFrA71A2j43RuDhqwySSQRSYhU4b1kPcYPQDm72gqjYaO2CwI/
	 jI6KvN1VBbz0LTd/Hee4DfxQKImHjnK/RnMQdOpTziM2JiD6f53ubS2fNeFmX6+oydeg5
	 a+j68lrQUTgoOJodFPpHPnCgu/uuXqGgHsO2DmPJ+slY9OarT05oI/T78VpOjU7wIpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Vir8602Q;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC1C606A321
	for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 09:26:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DC1C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Vir8602Q
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so83360245e9.0
        for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 01:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795771598; x=1796376398; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hoxVon0gybDyq4RET65wbSko4AYZRSn5g8mIkbvH3EY=;
        b=Vir8602QHCY48d/5HTYyW2E758IaVdN7MLnibn3ir1cJWZggbX2KVToMsfPGsh7pGH
         uVifU8phq/aN6ngKAepiCcDCApwHqptT+9947BVDpB9JDCGrNUO5roI3BaFwvFJPLZMb
         AQyrYQpnFsdckYnvvhPZW8ZXtQhubCiYIHiKhNnp/NFIYhqiDPhGX87HyiYxlODjBJOD
         S1kGzSpdaDYnu7u8c2WCKaiHj31BSDwUli7/seZyzP/JEG1PoeJPVJ7FzD1bU7J51N7H
         t9FQ+k3RLVI0qUN2/qRN3wFxmAMjVS9p0a9IBtakY94L4RiiL2dGtevWcQWAVe212VLE
         JBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795771598; x=1796376398;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hoxVon0gybDyq4RET65wbSko4AYZRSn5g8mIkbvH3EY=;
        b=bN92uxmq3dsuSWPbNDrdZBVtuIIbXQUCme2jz8DzeoaGspWbLZuUpT7b7BW8vlqTFz
         ZEAtU/+56eIZ3wh7fhSpTNJThzJfkXsqHtp6MHEMaMXEgnfaH7xmnubAL7c0cTLR67fK
         45DaMccOkhNgpxfWLlrEaBc/8C4rUGq3iRpYmo9j9R6o/IuEIAiFtRYk9wEnVQu/DSWr
         xvvaSAuZtUG8CznKi2hz2pyjN53agG67Lg0hJ9HTF+BbURA32pbLIOrw+rnANj91eXIc
         bNZZ0JUYLS5j6ev4Wn8Hb50krOmtaT8ML95bvBQgsvm4CkLA091NrZXILRPtFA+JBRzO
         mvNQ==
X-Forwarded-Encrypted: i=1; AL+hErGoh22kBvykRPGljHc5CvutxyRU8OQr35agJXtCBF2muqvIai2IrhAdNDSk8djJm3H9VcyNxgVn@vger.kernel.org
X-Gm-Message-State: APuU4Z8Z6HLHm0uNWyd/1ziuEA6AzBWGnzV2DIJCR8n5BiR9Ztk1jVGD
	r6I6VOjJfrMm1QdBc1e/gnE/HV9J3aUqEez0dZ16x2LyC2ST9tBIXSiZaBgcVYuXD34n/MpkGvO
	7BOCPvWg=
X-Gm-Gg: AZFdTZe2gkZ45cht7f9PChio/3DaGX1Axj0DUWVB/rDOHatTpF4XN1/oa6Dl80SA6Wi
	lLXanjcdD+XhEVIY+QSzSeQa7UjyjYCjQn2USXqhP1jqqvIAdUU2Rr4dWedjD49ecUD7VALEmMT
	BMJIpR0+hpU9JiHX/VtnlbnNRNTtCEecKqso37CrtxxrIc00tJjs02dQ2QbPQRaFAy/C54WpzTB
	vfiLinsb3IbT0Up/NUl1+F7F+5kA+x4soYRtoTINKtNu+vNu+SQGFMUFDj731BUaR/IGPVDbp0X
	Tj6xjce374wcYWo87HKdTNvIX8hhRkVCoTcI4M/NNId3glXomtePCOGAFiwglYJ0VCVC2ts9quu
	Un33onCuKMkE68NTZf65Yb+Ex6MA25YwfEZe2ilmhTeyo7pr097ks0bDBP1zfUGZmyXXv/hL7cE
	Tabd4gZMSXVj8FBflwcQ9PcmwM+E8s6NQilgqFwpavN1Dx2yPUXUM6tkb/SE/jp5UGpGhtOZg76
	Wn2J0NT8TbMR7vEw/ByjquEMS6clqw2gkd26sa5ydnwDgiihzwP14AHSobcuYHDYcFqAk4L6nAC
	OGPpAyonhUE0kjIEpmT/TWk3YAOmuuOXyKJzKQie
X-Received: by 2002:a05:600c:3ba5:b0:4b0:a307:46f8 with SMTP id 5b1f17b1804b1-4bb8880f29bmr537393335e9.10.1795771597616;
        Fri, 27 Nov 2026 01:26:37 -0800 (PST)
Received: from localhost (109-81-21-11.rct.o2.cz. [109.81.21.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2e6dsm44430440f8f.6.2026.11.27.01.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:26:37 -0800 (PST)
Date: Fri, 27 Nov 2026 10:26:36 +0100
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Greg Thelen <gthelen@google.com>, Greg KH <greg@kroah.com>,
	Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
 against filesystem freeze
Message-ID: <awlMzHMo6_Vj7gmq@tiehlicka>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
 <f188775aea9580f9ab2b477788503434@kernel.org>
 <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>

On Thu 26-11-26 18:02:28, Andrew Morton wrote:
> On Thu, 26 Nov 2026 02:17:38 -1000 Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello, Andrew.
> > 
> > Your follow-up, "mm/vmscan: scope freeze writeback skip to the reclaim
> > target", applies on top of this patch and tests fine here.
> 
> Cool, thanks.  I'd forgotten about that ;) It was a hastily slop-coded
> "maybe you'd like to include something like this in your patch" thing.
> 
> Can people please take a look and suggest whether it should be a
> standalone patch, or just fold it into this patch, "mm/vmscan: Fix
> legacy memcg reclaim deadlock against filesystem freeze"?

standalone patch. And quite honestly I am not convinced we need this.
Let's see what other memcg maintainers think but I would keep the global
thing as this is a global situation.

-- 
Michal Hocko
SUSE Labs
