From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH -next] mm/vmscan: fix an undefined behavior for zone id
Date: Mon, 11 Nov 2019 13:05:16 +0000
Message-ID: <20191111130516.GA891635@chrisdown.name>
References: <20191108204407.1435-1-cai@lca.pw>
 <64E60F6F-7582-427B-8DD5-EF97B1656F5A@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ptfgZiJrJRT37KV6qx/ANFTtjHXD6glvvm6dcn8VVZI=;
        b=BDGOjdrOiR/70UcRqMcVVH7VffzPCSZLLyoX5htmD99qQ65QbHEdi1A94TTEZKTGia
         bu4YKgChFJqm9P5eaC7FDAyXwIxRw7WczK/jDbRGD+k2jvtrx4tcCibk7Aa52STDdVIb
         iPIO1FJHqec/eDyz5qyxHqj3PBz5G2DEVuBfw=
Content-Disposition: inline
In-Reply-To: <64E60F6F-7582-427B-8DD5-EF97B1656F5A@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Qian Cai writes:
>> On Nov 8, 2019, at 3:44 PM, Qian Cai <cai@lca.pw> wrote:
>>
>> -    for (zid = 0; zid <= zone_idx; zid++) {
>> +    for (zid = 0; zid < zone_idx; zid++) {
>>        struct zone *zone =
>
>Oops, I think here needs to be,
>
>for (zid = 0; zid <= zone_idx && zid < MAX_NR_ZONES; zid++) {
>
>to deal with this MAX_NR_ZONES special case.

Ah, I just saw this in my local checkout and thought it was from my changes, 
until I saw it's also on clean mmots checkout. Thanks for the fixup!

Acked-by: Chris Down <chris@chrisdown.name>
