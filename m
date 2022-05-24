From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: add the mempolicy
 interface for cgroup v2.
Date: Tue, 24 May 2022 14:04:33 +0200
Message-ID: <YozJ0SNOjO3m4ehp@dhcp22.suse.cz>
References: <20220524103638.473-1-hezhongkun.hzk@bytedance.com>
 <Yoy3wDh0cvziWGHJ@dhcp22.suse.cz>
 <CACSyD1N4VeWBOzZwBogDW-wBbLvF54VrZ1Z+p9NFiXY+etuDJA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653393874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kt6lRreumMR82QxTIV2F0todF1CGcv8SrAK54H/AV8A=;
        b=W1eYCUa3Gc34WBARqY6Z4kLP1JcTMqeIR8a203LcNCcnfhIJGZXU4XvcbMblM5ifce7hs9
        l3qlXUc7EIsXHl2hRqLmWHxad74fKSX1lTrYgtR6v5CXB0yaCAo8dzWKeLQbCrKBaLnlp6
        Kptviaf5cYuvAYHoxvGS5a0rFRrmUoE=
Content-Disposition: inline
In-Reply-To: <CACSyD1N4VeWBOzZwBogDW-wBbLvF54VrZ1Z+p9NFiXY+etuDJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?6LS65Lit5Z2k?= <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Tue 24-05-22 19:46:38, 贺中坤 wrote:
> Hi Michal, thanks for your reply.
> mempolicy has two functions, which nodes to choose and how to use these
> nodes. cpuset can only decide the first one，it equal to 'bind' mempolicy.
> If cgroups support mempolicy, we can continue to develop more policy
> types. For example, allocate memory according to node weight, etc.
> We would like to have more precise control over memory allocation in NUMA
> server.

Why cputset controller cannot be extended instead?

-- 
Michal Hocko
SUSE Labs
