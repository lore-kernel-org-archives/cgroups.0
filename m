From: hanjinke <hanjinke.666@bytedance.com>
Subject: Re: [External] Re: [RFC PATCH] blk-throtl: Introduce sync queue for
 write ios
Date: Fri, 16 Dec 2022 09:36:07 +0800
Message-ID: <2bd8080a-6b57-124d-c3e0-6d5baf4c2ce8@bytedance.com>
References: <20221206163826.10700-1-hanjinke.666@bytedance.com>
 <Y5et48VryiKgL/eD@slm.duckdns.org>
 <1e53592f-b1f1-df85-3edb-eba4c5a5f989@bytedance.com>
 <Y5tPftzjXN6RcswM@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUxgBUchjwfFgwVAeUZQZdjmftiHITCsE/ZmyrGERkU=;
        b=mdtb/tPulG/eVWDSw679Lrwa7QpZngLol1fZQKHbE1PKOGFUbwuGWOvkcGfRewp6C4
         0oJDkz3zRqQNoNs5XcwiHZXnPPNtE7YJqvaznHg1asrR7IvO74Smf0Zz3DWfOGADJeL5
         i6Yon1OAe+Igj6MNkP1ZzTB4gATPzqhaZcyn4FECAq0eNpfTzsrY/4qN6/5Vak8u5p1j
         Cwbz3TH2ASjWQtWBttF0XHW+FvE5DR2fx3CZKvAAaAHXNpICh8B0ZAeNlme5acUYVbpP
         yEX9u+tX2f5FtvkHAp1bRxS1u/QzwNcNrSpGshNreNvuYU1OmXpwquDmvvtKFWcSS6gb
         dQyA==
In-Reply-To: <Y5tPftzjXN6RcswM@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



在 2022/12/16 上午12:46, Tejun Heo 写道:
> Hello,
> 
> On Wed, Dec 14, 2022 at 12:02:53PM +0800, hanjinke wrote:
>> Should we keep the main category of io based READ and WRITE, and within READ
>> / WRITE the subcategory were SYNC and ASYNC ? This may give less intrusion
>> into existing frameworks.
> 
> Ah, you haven't posted yet. So, yeah, let's do this. The code was a bit odd
> looking after adding the sync queue on the side. For reads, we can just
> consider everything synchrnous (or maybe treat SYNC the same way, I don't
> know whether reads actually use SYNC flags tho).
> 
> Thanks.
> 

okay, the patch v1 will be sent based on your suggestion.

Thanks.
