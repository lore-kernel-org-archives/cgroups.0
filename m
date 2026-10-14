Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56623185B48
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792009831; cv=none; b=pQak6CZ4+fUobYP/8kp5+RAvWtZ7Q56cXZW+5JsonfrtNuPwVmNM3puXbRiK9pukL1m6nMt0azDnk07gDRKGTwGhaj88/fyEOG3H9p55vgTA1doeoJJTtPxKTKtcB8prSp68Ct4qi8WDigeHZ28A3hXRGOQzRPqNuqJZ9p1YkqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792009831; c=relaxed/simple;
	bh=m13NBzcveU+SKQE3j2uf1MErjWzIeo/6YD0bhzhmMlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjYd7ujnfq8Ykq13Zdp1JmZLBypiuwLhps3YrlIyTc9JeD13zkcvWStGBw6yRMQaIuuOFKYPqF3Av9mr2ywesdff60wGEVPBkfPVdltw8w0nI3SlK9AamSG5P/Qy24FCslokLlZSq2bWrS4DkojlXu6khBLsARRnA1Jiv8Q/S5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=RVMXw0fL; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="RVMXw0fL"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93e503815adso319645185a.1
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 13:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792009829; x=1792614629; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yaoYiNsU7mJl5B1XUBRs0KY4FNWwAjLp6a5fD5J3icY=;
        b=RVMXw0fLh1vBFhHveKnAXQ6Hz+mLSbomQhj7r1PIYaBj2UQwe96OfhsykcALNTowpR
         aRXmLe7k4Fek2ZYTki9CQHjVtpgQPLWjnDUAoA0FFIzCzuGBhgEFHknq5jMeiPWn6G0k
         Ne2ZPz/YBumkl4IGhplpfHxovg0H4KCG0jdIYNPHvY7Z0zywYBY8Yu0KHAKbNar0Qcy3
         GTfYL+FnlhAlc7Za09zm92vc96rdkKIefX8FYBgo+6LpPJrQLhiqB8sd8pdAHAFlxQoE
         Rf7qKQiBAVgXwdWpDsWC/5p0rZbyxDtusTjutolKLdIJkRL2gR3i3QKU4x2KSfNXbxm7
         7HKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792009829; x=1792614629;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yaoYiNsU7mJl5B1XUBRs0KY4FNWwAjLp6a5fD5J3icY=;
        b=SsUvgnTGbPm6qQjkn9IQjKcQ9Fb3wGlLug+ebmS6o8oGzc56FTQSqhakoMRaXnsMk4
         gbnH9Hzd6W8/Fay+FE/NVBJPYLp7mBbqJNQSOhpuaQ2HfAN1jHktdooiT70Kdxxv60Lk
         waQexITqzyEfLcmoxUtOGavIoJAxGkPf1fKmgVrh2rVLcYW2WgCX7YCmHBD1JyLFt8QT
         BYMC6ePVDCk/RFtAPIsgNsOCbIiLdDchxWMTWCACG/pecfIzqqCTug/oi8/Y16GzQSOW
         PUcNMdlqeiKDfC5+/wMndat0N0y+jhLUUvNgUMT3NKm/YJraWd/R1SHz4UcZCHWdata9
         Y9pA==
X-Forwarded-Encrypted: i=1; AKwUvBwhGj0YX1TiESSgc50AH8cyj0dSDypMg9xZamOCkc3Ae642/v2NV9DaFw7cUkfu+18ZnXQtrQag@vger.kernel.org
X-Gm-Message-State: AFq9FYLjVrkxxQN7q45vAkqn1azE7EHU3CmGgD2aVfiqp87NS+3+mcz9
	TK/3RcUMlLeIGWsDMP55VgQXAtVGf4qplmgbks4lXDRM7OOSPcRPP6fsXvKlFUFNGmc=
X-Gm-Gg: AYBFou3QeLXG0NguEHYTr2wTtsgwEf94wB0ZofBNDP6iov/fgGsiEUAxcCO1x5dJdZz
	jc/FpNI8a66hA/T0Tp9oTV4yctPNK7QSJBASWpoz3M30rTtSpITTB4ID4qWsCjKfHi5aVRIEEpp
	gw3Fbwvo9BU8AkmIt/vuE6YO3xYN4oBSbzkvv70klN1gGJ3xLQB1r4lQ55kcqCOMO1+5rHlqymN
	AO2/i7PfKo338216/5FG0WL5wuIPxi/NO+bQQafVrNuLe2+7Zh6/V0Ok34IeistGX9EXN2WAh+n
	paH7TbGyWfPLamgjWFwOxlimpZkp9ERSbjR6o/8KRlvaYVx/OZhW3tOGsoEW3wChC/scp9ZfA02
	gGPkELwosmGkRG12MUrXqtVpgEWBiQt3GvaJt+N0uFL32RBnd7tysSK7q2BLbFIXNfXaLd+Bk8f
	6C7P6O/OXqmInVYLFTg/0++sAleUPrCy8lw9sNfMjBfqQZEBchKZYQHay6Ebm59a3ottuK
X-Received: by 2002:a05:620a:26a6:b0:93a:c102:1123 with SMTP id af79cd13be357-93ebd1bb363mr2748648785a.15.1792009828985;
        Wed, 14 Oct 2026 13:30:28 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f0cfac145sm64291685a.31.2026.10.14.13.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:30:28 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:30:27 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
Message-ID: <20261014203027.GD371161@cmpxchg.org>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>

On Wed, Oct 14, 2026 at 01:08:20PM -0400, Tal Zussman wrote:
> The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
> switch to native NR_VMALLOC vmstat counter"). Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks Tal
