From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol: return 1 from cgroup.memory __setup()
 handler
Date: Thu, 3 Mar 2022 13:53:03 -0800
Message-ID: <5130da56-0f22-8212-0ea3-6ddb8a8f5455@infradead.org>
References: <20220222005811.10672-1-rdunlap@infradead.org>
 <20220302185300.GA19699@blackbody.suse.cz>
 <9f8d4ddb-81ce-738a-d1f7-346ff9bf8ebd@infradead.org>
 <20220303101406.GE10867@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=sct51wRdcOdh4/CUtiuhNhf7LaEDw3Kb0tD5nil9ssQ=; b=nQ2RXZ8gjdMPqZZFrcN2/kZvXn
        n2AmG25tiHr4++jCKRm2sE9EKoOyPaJtTco1260U63kPyifVNs1XrwE+71B+kK3aGTKWmxs/kkIpw
        TQS5oy3EGHrZ9jsdz6w7xEFPyImfGl9k8+Z55esk3IGjcHMa/H+W+WKJQtQv/ivyg0OaWkrE2Vux2
        jMPabgJQA9VqX9qxQnqVN78uExie7OrDxuJj15gK8kOuOct3f7KG9GFaOzAuUeTmccXD8lrN+ohYB
        HBfNmGfOSExmZcUen/OyRCANVCPvOh/V4DWx5hZcNwOcaw4KDRkljKmgYdopoREE49Phzfp30prli
        L82857cA==;
Content-Language: en-US
In-Reply-To: <20220303101406.GE10867-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Igor Zhbanov <i.zhbanov-4G3FwjhnV40EXkLx5dDeUA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michal,

On 3/3/22 02:14, Michal Koutný wrote:
> On Wed, Mar 02, 2022 at 04:53:19PM -0800, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> I don't think those strings (even with invalid option values) should be
>> added to init's environment.
> 
> Isn't mere presence of the handler sufficient to filter those out? [1]

What is [1] here?

> (Counter-example would be 'foo=1 foo=2' where 1 is accepted value by the
> handler, 2 is unrecognized and should be passed to init. Is this a real
> use case?)

I don't know of any case where "foo=2" should be passed to init if
there is a setup function for "foo=" defined.

>> I'm willing to add a pr_warn() or pr_notice() for any unrecognized
>> option value, but it should still return 1 IMO.
> 
> Regardless of the handler existence check, I see returning 1 would be
> consistent with the majority of other memcg handlers.
> 
> For the uniformity,
> Reviewed-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
> 
> (Richer reporting or -EINVAL is by my understanding now a different
> problem.)

-- 
~Randy
