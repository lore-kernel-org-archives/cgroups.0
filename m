Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D504908DE
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785173046; cv=none; b=RQkEgC3jUX43NasmtkGPq0cscKtkdLyVIsqHczPMAQ0V+RRh+0X25ur36OUBjfvF3ZVTTaoD0zl5Y6jknd/vcqUAxkWqEgVfqSznpyI4VsLuJgNEzGMYX0uiRrH2xDwEG0fIg3cTiaglnlxVY440NTPhhsuQXmPsUhGKniyrstQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785173046; c=relaxed/simple;
	bh=86xgqvGoiJYEvC6CRR4sg1jka1MinI8d71SGwIWWI4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQgYVhsSYIKckOY41WL9dp/jGrdMa7B8aP6UiEQf2Cg5NFQ7nf4W7t2bpcPENs4AXVUdP9p5Oq8f6b7bYsG7LHZNDsM2DURF9aywzNx1wZ2JiaFXoEJMjRsVDGAg8DN3Axnroh1Dftpufn5na/V2IGbFEtDMGspHLbJx1vmfN0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=Xi7pC9k5; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="Xi7pC9k5"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so33660256d6.2
        for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 10:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785173040; x=1785777840; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5/ZbfBCCG0jHDBCNH9TydT1nctmDeBJrWwsqu8EzeJ4=;
        b=Xi7pC9k5rYhfP1gTkYxi9O+6oip5EDkt/j9ELZmzPHuzj4G7HtJBF25x/IhTWSNlNR
         cIrYaaD8gcnWcJkUJNhai/10rrQ3QinxonklmhL8jF8dhsnMau/s/zQenExEdT7VCCNu
         cLMiew+jHP0yOELSxiOCW0cAjDXCsgb4Rl/eP0f1tEsSHpGezZ7X9r4z36G/f2cx4W/d
         qrGVCjL4t+xpQ2iURUBsD7Jk1yCWUyLdnbnCPbUVoQVzjOaI+V0/0fxmaMLOC90R/OHp
         lBessL5uQvY4DvPtbjp/L/uKbCioj97XvTsosnfB6B0ArNrtyNDY3hgB0LrJJorG40Ui
         a0UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785173040; x=1785777840;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5/ZbfBCCG0jHDBCNH9TydT1nctmDeBJrWwsqu8EzeJ4=;
        b=RIiEMX0hKeeUI75GTIHVVKZ2hVjeSHMG0mRv77+l1rr9Ep/rp6cBueBT93NCFetRiR
         yBG9e4QqkIkMQG4Pi3UFs8YIpjAq3zB2PN1s3yAdEoc5yUwDh52D0pThZMJGifccPltD
         WAGBE9zWzjLnU7vcIIe3koEjQji7l/ic3Gzmcdx6GZgzMMtHKV9sf3Nu+2wDSscFTgeg
         YXLiDk9EkqKL/ChAciL7tPNp15SWyHv3YR99om9S+HOh/5jMssjqsi+cPuamWiBxDEW9
         HWpSXlO/IgX+fQq8zusBWKLmoEe5aLrpOOAbcSd8ssNEgC83LRLtaZNqBBmRP7/4H/E1
         y2CA==
X-Forwarded-Encrypted: i=1; AHgh+Rqd4mBgd00Fy74LaGRmiCzi7bEWkFZ80Mki652j3EIh2vyiwsYXFTFbN5ylaBdBtHYljZPzinYT@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzpy01UmkkTo8H9ZBcat3/TcJBv0Y9mSNWxukmYSe+d3uo1TDE
	7hDUVofJQsUiBROHx+pzvYq09S68Zuhtsw4qNMTfTCC+3mDp06XfXvEukdUfmOdt7c8=
X-Gm-Gg: AR+sD11FjT5bqFdiweEM9L1ThZu5twgFITb6Z1VHcViVOmqXZR6B3uyjJ5ENosSENMc
	7BM2pUAAl62FClb9kYXYVKqMU5oJsIusRrX+eDnee0+yRLvYwocF3cMM4ri9Zr7ToH1pyLk0NUJ
	L2jZIseDnt6ov71aSMMP3A0O9c6kX1+dDud71TteLz8vZeze5JnSD/SEN7BirIGuQKYf3QPpK7P
	0t1lBp3rY/bq2PZrLhBkNKQGNcVci/rFMeDGcGbxkdz4ADUPPNBhRDmQ0JGSGAgPtSKgmJe9oAh
	NhScCdh9W+UDVcaMwQz9mRRNodMOpfzZCQX0MvTXxi/2CeDbWopin8LQ/MclolY416hvnocorey
	zLtRay5SW1aZrKb2oZ5Kd1nM6jezc6XMhJWXt/ymuFWWDJtT9rftA6pBHWQtvRisA96YAz977M0
	V3hecQr4zoditiozA8Pj79JpU6og1MVNCgzVr45Fgg3FNisqUhdww4szA06atyPICaJCR0jmU=
X-Received: by 2002:a05:6214:e6f:b0:8df:93d1:ca18 with SMTP id 6a1803df08f44-90812689696mr6173636d6.3.1785173039676;
        Mon, 27 Jul 2026 10:23:59 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e858c4c1sm69737366d6.22.2026.07.27.10.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 10:23:59 -0700 (PDT)
Date: Mon, 27 Jul 2026 13:23:55 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, roman.gushchin@linux.dev,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v5 2/3] mm/vmscan: add pgrotate_anon and pgrotate_file
 vmstat counters
Message-ID: <ameUK827HSgx77kW@cmpxchg.org>
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-3-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727162550.2032-3-usama.arif@linux.dev>

On Mon, Jul 27, 2026 at 09:23:24AM -0700, Usama Arif wrote:
> Reclaim can spend substantial work on an LRU type without immediately
> reclaiming or demoting a corresponding amount of memory. Record this
> work in PGROTATE_ANON and PGROTATE_FILE.
> 
> For classic LRU reclaim:
> 
>   - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
>     corresponding anon/file counter when isolation succeeds.
>   - Active-list reclaim adds referenced executable file folios that
>     are retained on the active list to PGROTATE_FILE. Active anon
>     reclaim does not contribute this component.
> 
> For MGLRU, add the number of initially isolated pages that remain
> unreclaimed after both the initial and retry passes to the counter for
> the selected anon/file type.
> 
> These counters are distinct from the existing pgrotated vm event.
> pgrotated records an actual move to the inactive-list tail, primarily
> after reclaim-marked writeback completes or failed invalidation leaves
> a folio for accelerated reclaim. PGROTATE_ANON and PGROTATE_FILE
> measure reclaim cost and do not imply that a folio moved to an LRU tail.
> 
> A subsequent patch will consume these counters for anon/file scan
> balancing.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
