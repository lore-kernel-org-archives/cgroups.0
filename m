From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC 2/6] cgroup: gpu: Add a cgroup controller for allocator
 attribution of GPU memory
Date: Wed, 19 Jan 2022 07:40:30 -0800
Message-ID: <aea5b741-c994-4007-156e-d8a3a5b9bbcc__41341.1272851349$1642606904$gmane$org@infradead.org>
References: <20220115010622.3185921-1-hridya@google.com>
 <20220115010622.3185921-3-hridya@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=pxPDysxsLzRS9m3h8MM0+hZnUy5KDuxOZAnHkZ+LiUU=; b=P6ZwT2AKXUwgwui+4YXZ3+S5JB
        aHNGnZbcF7P0JjQ2N9a3uww5zTv3szmJXvjflxI/R9cm4iHHtjkTZlZZnN7sPr7B+1C6nCW3p0fqX
        DYFOssgLzTGUjKwS6687wmMBof+9C3nc7L2X+Ie0WIui7iCrANpuwmi9xVW2ufFYlQIuY4UQusx9I
        aK7D6KPidQ0p0zcs86E7CjnpH2pWzCpNCPEf30CwVb0ikL3hGDBb+Iqwm4CoClWea/Kn28LragZYK
        sr7sXjUvS/ffkG8+oNECDa6fOeeafsWYlPwh6Kmn96xrLnm5RgXLjTPl+64wXXpx/WxZoNk1VVkXg
        ++56dLGA==;
Content-Language: en-US
In-Reply-To: <20220115010622.3185921-3-hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Starkey>
Cc: Kenny.Ho-5C7GfCeVMHo@public.gmane.org, daniels-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hi--

On 1/14/22 17:06, Hridya Valsaraju wrote:
> diff --git a/init/Kconfig b/init/Kconfig
> index cd23faa163d1..408910b21387 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -990,6 +990,13 @@ config BLK_CGROUP
>  
>  	See Documentation/admin-guide/cgroup-v1/blkio-controller.rst for more information.
>  
> +config CGROUP_GPU
> +       bool "gpu cgroup controller (EXPERIMENTAL)"
> +       select PAGE_COUNTER
> +       help
> +	Provides accounting and limit setting for memory allocations by the GPU
> +	and GPU-related subsystems.

Please follow coding-style for Kconfig files:

(from Documentation/process/coding-style.rst, section 10):

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different.  Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces.


thanks.

-- 
~Randy
