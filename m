Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8086D503BCB
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 16:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789748655; cv=none; b=J8mnHHhyo2Prhz/vTWwbpupP9SGdGAv9tazyb3tF1PlpASkt0n0Gh5gbk/ufAmwE8rRD5y/xuoqze6HSjzwgPcJxS/T+YD35rXDR8Xzhm5gkoX+aMQJV69l0wJiGNqzV8Tk51CHR7hzxIxTAZgdWtm2to31slRGcm/iG64UbZr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789748655; c=relaxed/simple;
	bh=u2qNzscspgNjHmDHfUPnMbVtInEKJuHzmMhUl3PFTKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8alBQCQ8Ozf8acqJK1D7K7V8Evt0YIRtSgVGJAqpTgOrgBUeGHM2QlHirxOyYv910BZgd2VRffSA8Eghf5JJl2bamQTEriaf9EbhURh+GYlX/xfW5M94z0QM89so1jkL9ZQFeYkjyF+Oey/+rGWwhA64eZFWc/QtoK/+kCrnho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=VytQKG6w; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="VytQKG6w"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910c9ff1fso108404285a.2
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 09:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789748651; x=1790353451; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=22UHuqAYfKNfgslt+w3Gb+mOi1pe1zYpAqvus/G0CRA=;
        b=VytQKG6we8ypXfNkrDDwlg8IqE83rQF/jMlzJ+3yNfQlrmfmb/Y7MemRi7gj5SfL/y
         MQyrFruwPdIhgI2pEkiiAc0sFLcuKMErbJT223jkceruQAQUuvqP6vfW0W3llJYvLHu5
         9+D2CPJ677y37AqCHON/iDgtjWjVFVt749rFkwcysGQlHc2eWeoyhAXsmzPhQxNlaMqc
         DStAw3I89w3pe799zJyGB+mx2jUu1NnvSmMQhPgFh3OirhL+aHqaxAN5edwLp2HQtIAS
         qC6TBXMw3IDr1E5VRZZaBSFZs+PmV0HiTQU/BJP60H3/SJ1hEgAwoj0O53b0ZBuRaWjS
         axSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789748651; x=1790353451;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=22UHuqAYfKNfgslt+w3Gb+mOi1pe1zYpAqvus/G0CRA=;
        b=2yluFKrv5AXdDEjbhx7wvVY8/TLQUnSt4jOOK+OQWfb0nI68plihTz1WtbnFhqAxwF
         XoFM3nJHAiRZT5jZWwHemsU5gUqul5OHvwxV0B9y/afiJiOLUzJeCpBVPXPWjnYH+Mhw
         iUIlDete7j0lc6OeHhPl978/zVh63oYh5/O4dFexzHJK2N1HGWzuVI/PcR3xE05gnkUp
         ToECqDaFpGWChUdtiFI2klsKvLpeNtKjNxW0102T8ZhCmwxCqi3kt4k00dQiEcVF7gKF
         DikMVDN7eR8GH/QHVVhWNS1welIuVfFed1YqeF5UOOzmur4aePuFGd3nMN6DQ2bJThdm
         BNLA==
X-Forwarded-Encrypted: i=1; AKwUvByWwSXfxkHZhe7JAfE+g9l3DusV/FGGKEwH9pIEXjGyRWM7vsqOYbsFZ7SWGsNA1NO4Mb58zG6d@vger.kernel.org
X-Gm-Message-State: AFuF++mJSYUbEJ7vTpD8I9Wn3rxdG9eHgC61+n7+ZhUIIOe7mLCj6I8p
	8+PM6rEjk42bH2+dqvqgT8UJ+0ko/TAZuBHieWspT1yUSPzFx5C0QYkUspIQ2N/fNP4=
X-Gm-Gg: AYBFou3YDY847mnWP5gYI3KH50gDRzjZ6E28AKEhg2aiS2ge09c8QEbft680wymaGWb
	QTtWs0C2yhhn/BcPkqcYjSCr8AHhybVjxxdQCTB/a1qgnhQd5ieqGXrf0uSnTufMcHVinYVUzfw
	JLN7ckPXdY1gVn0ivGo5vxyC+/GNgyNg2YasdSFmea1mSljL3WzmFXbTjWwRuou/Yle/rfcecUO
	R4nlTaNQiT6eX5Jie20VDhQNbYLyjYlSRqPiTS+3blPXK+i7V5+6af/MpApyhY5JLeoC5zl3DsI
	ohQAU2iBsBbKz+KVSbugMrVGzQJkRozwEFNf7FNahf6OW15PntCnGF3/VbvoC+SMH/g2WYFrC2b
	me0sFrk8y8Ioa6xgJx15aOY1EAwqhuOEejslRR+cgv/Qb78VBYkVdiPaGblkPEyuOMS6GmE3Z10
	yjX4YnxtzGSkriJCYdz7eAtYagbqdGQYMoM3VcWxYdM1kyZNk+KWxfU4+aJ9tT2HkbcLn70w==
X-Received: by 2002:a05:620a:4455:b0:93b:da6f:50a4 with SMTP id af79cd13be357-93bdc6aef5amr427968285a.36.1789748650894;
        Fri, 18 Sep 2026 09:24:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0e95a4asm173223285a.18.2026.09.18.09.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:24:09 -0700 (PDT)
Date: Fri, 18 Sep 2026 12:24:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tao Cui <cui.tao@linux.dev>,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aq1lqJdVZ1stTKCn@cmpxchg.org>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
 <aqxMk6yaiFHeeAAg@linux.dev>
 <aq0HNe5s3zvOnM_I@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0HNe5s3zvOnM_I@tiehlicka>

On Fri, Sep 18, 2026 at 11:41:09AM +0200, Michal Hocko wrote:
> On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
> > On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
> > > From: Tao Cui <cuitao@kylinos.cn>
> > > 
> > > The legacy cgroup v1 memory controller has already been moved out of
> > > the shared implementation at the file level (mm/memcontrol-v1.c) and at
> > > the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
> > > per-cgroup state, however, still sits as individual members inside
> > > struct mem_cgroup, guarded by #ifdefs.
> > > 
> > > This series isolates the deprecated implementation from the shared hot
> > > structure: all v1-only members are grouped into a dedicated
> > > struct mem_cgroup_v1, and every access goes through memcg->v1.X.
> > > 
> > > With this in place the v1 implementation is self-contained: its
> > > interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
> > > its eventual removal becomes a localized deletion of this struct
> > > together with mm/memcontrol-v1.c, instead of unwinding
> > > ifdef-scattered members across the shared header.
> > 
> > Sorry I don't see any benefit of this code churn. The code is already behind
> > config. What exactly this code churn is giving us?
> 
> The only arguable upside is that this would make it ever so slightly
> easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).

I had the same thought. It's kiiind of nice to see which members are
completely specific to memcg1.

> I am not convinced this is sufficient to justify the churn either.

IMO it helps that it's mostly in memcontrol-v1.c where the chances of
interfering with other work are pretty slim.

The patch 1 + patch 2 split is a bit bothersome: indenting everything
into a union, only to then move it out in the next patch.

Tao, if you folded these two patches to make it one clean extraction
and changed over the sites at the same time, I would probably lean
supportive on this.
