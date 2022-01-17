From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC 4/6] dma-buf: Add DMA-BUF exporter op to charge a DMA-BUF to
 a cgroup.
Date: Mon, 17 Jan 2022 08:46:16 +0100
Message-ID: <f8c8b196-7d12-6242-97ac-38149f3a3ba3__3109.77946953557$1642405606$gmane$org@amd.com>
References: <20220115010622.3185921-1-hridya@google.com>
 <20220115010622.3185921-5-hridya@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WabEuyZOpi6hrDKYblBKZo897m2mA5zex7rqbD8ZYyg=;
 b=fANnBJY54iPRC/9/VrZ/FrSVF54Km99fnS5QRZEPZuz7WUdhpwc7JcqI3s4MaWuz8SvZwQaoLzFb5SyHOwcQNK1RaESv/7SjBiD0GI7D3Hd2LScLV9ifHhis9lOFeW2Ct507o/ozw9EsjKx6zLxYkiJQ5uLaSojuKEB6orWlB4E=
In-Reply-To: <20220115010622.3185921-5-hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Starkey>
Cc: Kenny.Ho-5C7GfCeVMHo@public.gmane.org, daniels-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Am 15.01.22 um 02:06 schrieb Hridya Valsaraju:
> The optional exporter op provides a way for processes to transfer
> charge of a buffer to a different process. This is essential for the
> cases where a central allocator process does allocations for various
> subsystems, hands over the fd to the client who
> requested the memory and drops all references to the allocated memory.
>
> Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   include/linux/dma-buf.h | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 7ab50076e7a6..d5e52f81cc6f 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -13,6 +13,7 @@
>   #ifndef __DMA_BUF_H__
>   #define __DMA_BUF_H__
>   
> +#include <linux/cgroup_gpu.h>
>   #include <linux/dma-buf-map.h>
>   #include <linux/file.h>
>   #include <linux/err.h>
> @@ -285,6 +286,23 @@ struct dma_buf_ops {
>   
>   	int (*vmap)(struct dma_buf *dmabuf, struct dma_buf_map *map);
>   	void (*vunmap)(struct dma_buf *dmabuf, struct dma_buf_map *map);
> +
> +	/**
> +	 * @charge_to_cgroup:
> +	 *
> +	 * This is called by an exporter to charge a buffer to the specified
> +	 * cgroup.

Well that sentence makes absolutely no sense at all.

The dma_buf_ops are supposed to be called by the DMA-buf subsystem on 
behalves of the importer and never by the exporter itself.

I hope that this is just a documentation mixup.

Regards,
Christian.

>   The caller must hold a reference to @gpucg obtained via
> +	 * gpucg_get(). The DMA-BUF will be uncharged from the cgroup it is
> +	 * currently charged to before being charged to @gpucg. The caller must
> +	 * belong to the cgroup the buffer is currently charged to.
> +	 *
> +	 * This callback is optional.
> +	 *
> +	 * Returns:
> +	 *
> +	 * 0 on success or negative error code on failure.
> +	 */
> +	int (*charge_to_cgroup)(struct dma_buf *dmabuf, struct gpucg *gpucg);
>   };
>   
>   /**

