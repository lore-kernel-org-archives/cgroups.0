From: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [Intel-xe] [RFC PATCH 3/4] drm/ttm: Handle -EAGAIN in
 ttm_resource_alloc as -ENOSPC.
Date: Wed, 3 May 2023 11:36:52 +0200
Message-ID: <3bf126ea-abec-7e44-c9ac-0ff429e2001a@linux.intel.com>
References: <20230503083500.645848-1-maarten.lankhorst@linux.intel.com>
 <20230503083500.645848-4-maarten.lankhorst@linux.intel.com>
 <888841c4-7bd4-8174-7786-033715c995c6@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------vwH6Tjnx2mz1b995oCSxL25w"
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1683106619; x=1714642619;
 h=message-id:date:mime-version:subject:to:cc:references:
 from:in-reply-to;
 bh=MffWgZiRrbHn3+wIAetXWUaaQo9Vm7loAXSeTnnZ5i0=;
 b=FptxY2L807uYmL1h4tWylyIn+mGZvRfe4AtnVCenftST9ddTp7XZbjvj
 H4sVUbkMkrerOMDJNBgDdWKvpy916SK0R83+C0NkhF9k3toCNwPOMhyXm
 cVolqgMURDbdjuqdzVG1rWEUjDyw4qpD1y7GUSqqpXs1BvAmaXRvMC3SA
 xklscGFZFRSsrb9deRn91KNRupiPmbNdBGk3jiVVz0hhVS5zUr6cjai1h
 ju8wsbAm5mYgpLsVNmfJmM13acEPezc4H4V96ztdgVFNhGYyLe21+HZqA
 FH1lsYf4L0fhaH5M2O79E26hGlaVNoOAeZZM5P/D5lMLZTgU/D/NOl9Pb Q==;
Content-Language: en-US
In-Reply-To: <888841c4-7bd4-8174-7786-033715c995c6-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas.hellstrom-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-xe-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This is a multi-part message in MIME format.
--------------vwH6Tjnx2mz1b995oCSxL25w
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit


On 2023-05-03 11:11, Thomas Hellström wrote:
> Hi, Maarten
>
> On 5/3/23 10:34, Maarten Lankhorst wrote:
>> This allows the drm cgroup controller to return no space is available..
>>
>> XXX: This is a hopeless simplification that changes behavior, and
>> returns -ENOSPC even if we could evict ourselves from the current
>> cgroup.
>>
>> Ideally, the eviction code becomes cgroup aware, and will force eviction
>> from the current cgroup or its parents.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> Thinking of the shrinker analogy, do non-cgroup aware shrinkers just 
> shrink blindly or do they reject shrinking like this patch when a 
> cgroup limit is reached?

When I made the cgroup controller return -ENOSPC I just hit an infinite 
loop since it sees enough memory is free and tries to allocate memory 
again. Hence the -EAGAIN handling here. It returns -ENOSPC, without the 
infinite looping.

I think there should be 2 code paths:

- OOM, generic case: Handle like we do now. No need for special cgroup 
handling needed right now.

Might change if we implement cgroup memory semantics. See the memory 
section of Documentation/admin-guide/cgroup-v2.rst

It could be useful regardless.

- OOM, cgroup limit reached: Check for each BO if it's valuable to evict to unblock the relevant limit.


              / cg1.0
root - cg1 --  cg1.1
    \         \ cg1.2
     \  cg2

If we hit the cg limit in cg1.0 for only cg1.0, it doesn't make sense to evict from any other cgroup.
If we hit the limit in cg1.0 for the entirety of cg1, it makes sense to evict from any of the cg1 nodes, but not from cg2.

This should be relatively straightforward to implement. We identify which cgroup hit a limit, and then let the shrinker
run only on that cgroup and its childs.

This could be simplified to the OOM generic case, for root/NULL cg.


~Maarten

--------------vwH6Tjnx2mz1b995oCSxL25w
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 2023-05-03 11:11, Thomas Hellström
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:888841c4-7bd4-8174-7786-033715c995c6-VuQAYsv1563Yd54FQh9/CA@public.gmane.org">Hi,
      Maarten
      <br>
      <br>
      On 5/3/23 10:34, Maarten Lankhorst wrote:
      <br>
      <blockquote type="cite">This allows the drm cgroup controller to
        return no space is available..
        <br>
        <br>
        XXX: This is a hopeless simplification that changes behavior,
        and
        <br>
        returns -ENOSPC even if we could evict ourselves from the
        current
        <br>
        cgroup.
        <br>
        <br>
        Ideally, the eviction code becomes cgroup aware, and will force
        eviction
        <br>
        from the current cgroup or its parents.
        <br>
        <br>
        Signed-off-by: Maarten Lankhorst
        <a class="moz-txt-link-rfc2396E" href="mailto:maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org">&lt;maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;</a>
        <br>
      </blockquote>
      <br>
      Thinking of the shrinker analogy, do non-cgroup aware shrinkers
      just shrink blindly or do they reject shrinking like this patch
      when a cgroup limit is reached?
      <br>
    </blockquote>
    <p>When I made the cgroup controller return -ENOSPC I just hit an
      infinite loop since it sees enough memory is free and tries to
      allocate memory again. Hence the -EAGAIN handling here. It returns
      -ENOSPC, without the infinite looping.</p>
    <p>I think there should be 2 code paths:</p>
    <p>- OOM, generic case: Handle like we do now. No need for special
      cgroup handling needed right now.</p>
    <p>Might change if we implement cgroup memory semantics. See the
      memory section of Documentation/admin-guide/cgroup-v2.rst <br>
    </p>
    <p>It could be useful regardless.<br>
    </p>
    <pre>- OOM, cgroup limit reached: Check for each BO if it's valuable to evict to unblock the relevant limit.


             / cg1.0
root - cg1 --  cg1.1
   \         \ cg1.2
    \  cg2

If we hit the cg limit in cg1.0 for only cg1.0, it doesn't make sense to evict from any other cgroup.
If we hit the limit in cg1.0 for the entirety of cg1, it makes sense to evict from any of the cg1 nodes, but not from cg2.

This should be relatively straightforward to implement. We identify which cgroup hit a limit, and then let the shrinker
run only on that cgroup and its childs.

This could be simplified to the OOM generic case, for root/NULL cg.


~Maarten
</pre>
  </body>
</html>

--------------vwH6Tjnx2mz1b995oCSxL25w--
