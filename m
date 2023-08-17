From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH v2][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Thu, 17 Aug 2023 11:23:38 -0600
Message-ID: <32c7ea41-8b00-c92e-02ec-d535428e55bb@embeddedor.com>
References: <ZN02iLcZYgxHFrEN@work> <ZN02wFqzvwP2JI-K@slm.duckdns.org>
 <202308161356.4AED47263E@keescook> <ZN05IZBfaKkPKJfH@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XsIhFA6p1MkMu1lgiaxFpYzkM6VAgL0B/RLP+o3ibj0=; b=PPXTDZN3LckRmEB6i0+w8aLhVh
        bknx7JpDqM62KROQHLSlbSJQKUE2IzMxM6axtrpJ2xUrA00LnpwKOglWINcFWkSoLC/6RO/P2i5dH
        YJNak3Bae7X6n7PWsTS4NVAsABO6yq/RDV8DdVE90Tb92hYnCI9Il+2I12kkQP9XYyXwcxNZ1owNQ
        c6FZ9CHc7mvrYkbtBvye2XWtMmhAX3AsC0P3GyGbxpK5INA/jUloBKpMoUcCpgfyouWMe42Lq+U7A
        +EGL8HEDWMReC0D5mT1I86G0SI+sqt1KRWUAgAO+HP4ctNo/f11AeOFVa0SCtkw/6XuR1xoPoPRO1
        c5Lt 
Content-Language: en-US
In-Reply-To: <ZN05IZBfaKkPKJfH@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org



On 8/16/23 15:01, Tejun Heo wrote:
> On Wed, Aug 16, 2023 at 01:57:16PM -0700, Kees Cook wrote:
>> On Wed, Aug 16, 2023 at 10:51:12AM -1000, Tejun Heo wrote:
>>> Hello,
>>>
>>> On Wed, Aug 16, 2023 at 02:50:16PM -0600, Gustavo A. R. Silva wrote:
>>>> Change the notation from pointer-to-array to pointer-to-pointer.
>>>> With this, we avoid the compiler complaining about trying
>>>> to access a region of size zero as an argument during function
>>>> calls.
>>>
>>> Haha, I thought the functions were actually accessing the memory. This can't
>>> be an intended behavior on the compiler's side, right?
>>
>> I think it's a result of inlining -- the compiler ends up with a case
>> where it looks like it might be possible to index a zero-sized array,
>> but it is "accidentally safe".
> 
> Ah I see. It's not that the compiler knows that ** access is safe. It's more
> that it only applies the check on arrays. Is that right? Gustavo, I don't

That's correct.

> mind the patch but can you update the patch description a bit explaining a
> bit more on what's going on with the complier? It doesn't have to be the
> full explanation but it'd be useful to explicitly point out that we're just
> working around the compiler being a bit silly.

I just sent v3:

	https://lore.kernel.org/linux-hardening/ZN5WkbPelHUSTXOA@work/

Thanks
--
Gustavo
