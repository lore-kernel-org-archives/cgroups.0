From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 1 Jun 2022 17:25:53 -0400
Message-ID: <c26f153c-304c-e109-6626-bb8b79a2e2ad@redhat.com>
References: <20220601165324.60892-1-longman@redhat.com>
 <20220601165324.60892-2-longman@redhat.com>
 <YpemVpvaPomwH7mt@slm.duckdns.org>
 <ca091a5c-4ae1-e973-403e-4086d4527102@redhat.com>
 <YpexWFptr/l2Y0rU@slm.duckdns.org>
 <bca31669-7107-ebe4-7fbf-2449940a5cc8@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654118755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=txiTo+Ucs1cY72f13HTxzNAKn4FkAvrzSKX625EeB7c=;
        b=D1AEsZ+qdA3Vg7/Cv7Uzpgc78G3EpUsphgJPcsCIl7ar/0wPbpQgjnS931mw0hI6GjptTL
        t637c13J/aj5z2033roZ19fvvgsW0ImhsbUiHHex7EtC6Db+cCzZ8hZGXeEFVI+CELQOwO
        A+Mwrw0CySBcMePwLXHG31dxUQNLHpo=
Content-Language: en-US
In-Reply-To: <bca31669-7107-ebe4-7fbf-2449940a5cc8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On 6/1/22 14:52, Waiman Long wrote:
> On 6/1/22 14:35, Tejun Heo wrote:
>
>> Can you also add an explanation on how the pending llist is synchronized
>> against blkg destructions?
>
> Sure. I will need to think about that and put a proper comment there.

I think the best way to protect against blkg destruction is to get a 
percpu reference when put into lockless list and put it back when removed.

BTW, when I ran a test that continuously create and destroy containers, 
the total number of blkcg's kept on increasing. There are some freeing 
of blkcg's but no freeing of blkg's at all. Maybe we have a similar 
dying blkcg's problem here. I will take a further look at that when I 
have time.

Cheers,
Longman

