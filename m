From: Martin Sebor <msebor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/11] [RFC] drm/i915/dp: fix array overflow warning
Date: Thu, 25 Mar 2021 08:49:56 -0600
Message-ID: <44ad545d-cc07-2e5f-9ec8-ad848f39268a@gmail.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-12-arnd@kernel.org> <87wntv3bgt.fsf@intel.com>
 <CAK8P3a0HGiPQ-k6t6roTgeUvVAMMY=fMnGV0+t48yJjz55XFAA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A01xU9scL5QHqCTcEARA+UZXhX3w6QfTLVjGvG0qhWs=;
        b=fjIpx38pKKpF7tuHHnx+6bHTa8GIAr+gRLGjKt2x69P7v8gjKVe3W9dYqxgP9vSwI9
         QihvfqnQepbko6JQmAIRW+EQAppxHtxDBVpKo/ulTx0XeTA+TsLT2XPd5R47EHfs/vL+
         RcfmGpqKXdbxR340ysSTk2TR5aaFQcoTZCnFjyd/rFWDxI9wey0GlS/SNuFSvLhs+psi
         0EVXYddJbSDWFSlhrUt5I6M67vOMO/RGQOVQ0jvf2R4mqWnxzVz/163P9EVlylTqlOyg
         RuvSoLqCSa3d1HolOz0J7uXNfTUCd96jvr8FQ9pq7Hu06fFtmIslpU2LxY/2YEkWewFc
         MUFw==
In-Reply-To: <CAK8P3a0HGiPQ-k6t6roTgeUvVAMMY=fMnGV0+t48yJjz55XFAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Intel Graphics <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, dri-devel

On 3/25/21 3:53 AM, Arnd Bergmann wrote:
> On Thu, Mar 25, 2021 at 9:05 AM Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>>> Clearly something is wrong here, but I can't quite figure out what.
>>> Changing the array size to 16 bytes avoids the warning, but is
>>> probably the wrong solution here.
>>
>> Ugh. drm_dp_channel_eq_ok() does not actually require more than
>> DP_LINK_STATUS_SIZE - 2 elements in the link_status. It's some other
>> related functions that do, and in most cases it's convenient to read all
>> those DP_LINK_STATUS_SIZE bytes.
>>
>> However, here the case is slightly different for DP MST, and the change
>> causes reserved DPCD addresses to be read. Not sure it matters, but
>> really I think the problem is what drm_dp_channel_eq_ok() advertizes.
>>
>> I also don't like the array notation with sizes in function parameters
>> in general, because I think it's misleading. Would gcc-11 warn if a
>> function actually accesses the memory out of bounds of the size?
> 
> Yes, that is the point of the warning. Using an explicit length in an
> array argument type tells gcc that the function will never access
> beyond the end of that bound, and that passing a short array
> is a bug.
> 
> I don't know if this /only/ means triggering a warning, or if gcc
> is also able to make optimizations after classifying this as undefined
> behavior that it would not make for an unspecified length.

GCC uses the array parameter notation as a hint for warnings but
it doesn't optimize on this basis and never will be able to because
code that accesses more elements from the array isn't invalid.
Adding static to the bound, as in void f (int[static N]) does
imply that the function won't access more than N elements and
C intends for optimizers to rely on it, although GCC doesn't yet.

The warning for the array notation is a more portable alternative
to explicitly annotating functions with attribute access, and to
-Wvla-parameter for VLA parameters.  The latter seem to be used
relatively rarely, sometimes deliberately because of the bad rap
of VLA objects, even though VLA parameters don't suffer from
the same problems.

Martin

> 
>> Anyway. I don't think we're going to get rid of the array notation
>> anytime soon, if ever, no matter how much I dislike it, so I think the
>> right fix would be to at least state the correct required size in
>> drm_dp_channel_eq_ok().
> 
> Ok. Just to confirm: Changing the declaration to an unspecified length
> avoids the warnings, as does the patch below:
> 
> diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
> index eedbb48815b7..6ebeec3d88a7 100644
> --- a/drivers/gpu/drm/drm_dp_helper.c
> +++ b/drivers/gpu/drm/drm_dp_helper.c
> @@ -46,12 +46,12 @@
>    */
> 
>   /* Helpers for DP link training */
> -static u8 dp_link_status(const u8 link_status[DP_LINK_STATUS_SIZE], int r)
> +static u8 dp_link_status(const u8 link_status[DP_LINK_STATUS_SIZE - 2], int r)
>   {
>          return link_status[r - DP_LANE0_1_STATUS];
>   }
> 
> -static u8 dp_get_lane_status(const u8 link_status[DP_LINK_STATUS_SIZE],
> +static u8 dp_get_lane_status(const u8 link_status[DP_LINK_STATUS_SIZE - 2],
>                               int lane)
>   {
>          int i = DP_LANE0_1_STATUS + (lane >> 1);
> @@ -61,7 +61,7 @@ static u8 dp_get_lane_status(const u8
> link_status[DP_LINK_STATUS_SIZE],
>          return (l >> s) & 0xf;
>   }
> 
> -bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
> +bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE - 2],
>                            int lane_count)
>   {
>          u8 lane_align;
> diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
> index edffd1dcca3e..160f7fd127b1 100644
> --- a/include/drm/drm_dp_helper.h
> +++ b/include/drm/drm_dp_helper.h
> @@ -1456,7 +1456,7 @@ enum drm_dp_phy {
> 
>   #define DP_LINK_CONSTANT_N_VALUE 0x8000
>   #define DP_LINK_STATUS_SIZE       6
> -bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
> +bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE - 2],
>                            int lane_count);
>   bool drm_dp_clock_recovery_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
>                                int lane_count);
> 
> 
> This obviously needs a good explanation in the code and the changelog text,
> which I don't have, but if the above is what you had in mind, please take that
> and add Reported-by/Tested-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>.
> 
>         Arnd
> 

