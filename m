From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH -next] mm/vmscan: fix an undefined behavior for zone id
Date: Fri, 8 Nov 2019 16:26:52 -0500
Message-ID: <64E60F6F-7582-427B-8DD5-EF97B1656F5A@lca.pw>
References: <20191108204407.1435-1-cai@lca.pw>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=E/re/TtVqjhhFyMNUDrEMQoMA+rNSBWgaDnjt6xblfc=;
        b=BGsscPnI0I/AhxQtkp1ur0VrFYXf5H8Fg7QmP8nllWAk3LB+1xRvuro/YNq+Wi4p5F
         3ZAD5u8+aHKV6BCRpJFppf3VuxZKf/sv7n021xyePsMo0qyk4ioIipKyJxsfny2R6RX3
         muOR0J1B2kxQSzV9581+eZYOESV3d8dZz1I/0lFZM3rKt3ovoGT+VSWRIahQ6OsN3IV1
         s8FtMLqcLzCVTjdBygGBm4m5G43Y6e3kQ7cTLWjekKCGP5ylAKVgqVGK8DUT21Ht4cN8
         7GXkMXTsKy8U08dIiAi7+G9AKRSNl22O/wb8ep0nz17TwjAIvaYLFkN2KBK6QMSY1A7d
         ming==
In-Reply-To: <20191108204407.1435-1-cai@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



> On Nov 8, 2019, at 3:44 PM, Qian Cai <cai@lca.pw> wrote:
> 
> -    for (zid = 0; zid <= zone_idx; zid++) {
> +    for (zid = 0; zid < zone_idx; zid++) {
>        struct zone *zone =

Oops, I think here needs to be,

for (zid = 0; zid <= zone_idx && zid < MAX_NR_ZONES; zid++) {

to deal with this MAX_NR_ZONES special case.
