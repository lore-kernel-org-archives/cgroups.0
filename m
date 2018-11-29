From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 05/13] blkcg: associate blkg when associating a device
Date: Thu, 29 Nov 2018 07:53:33 -0800
Message-ID: <20181129155333.GE2509588@devbig004.ftw2.facebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-6-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GyIEYhvdRvJJ7cA9IrZUO0BaASlbo8wDkHEXFN/2IZI=;
        b=Yu5HrG6Via1jLCrMSeRY46VC9W1qnplO9X99/sbLV3hOCZQHRmll7T15VMunYtUkmd
         r6ZBbA4Nvae2WL/X+6NoIU+UwUbAL+afGzCzqtKFyRzXFR/6Hk9j8A0CD35J9O5RZ7wF
         DzUThCR0vYWT2qQY9X49fcICosw41pKdoL0gEW+bW8IuRzTmxy35L8iW/kw2Pkj+P4/M
         TKjCfttb52tlX7LsRtNxd1a3Hx3PNE+bWu2IZzp7O2Oo8gSDE+xAxwkC2Z5O5nng4JCg
         41+MKpxjW2URix2FDjrqSLT494f6d0DlZTPdWA9DoEBo0UH0Eyb5dePDI+JDdY6Rzddw
         cHcQ==
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-6-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 04:19:38PM -0500, Dennis Zhou wrote:
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 62715a5a4f32..8bc9d9b29fd3 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -486,6 +486,12 @@ extern unsigned int bvec_nr_vecs(unsigned short idx);
>  extern const char *bio_devname(struct bio *bio, char *buffer);
>  
>  #define bio_set_dev(bio, bdev) 			\
> +do {						\
> +	bio_set_dev_only(bio, bdev);		\
> +	bio_associate_blkg(bio);		\
> +} while (0)
> +
> +#define bio_set_dev_only(bio, bdev)		\
>  do {						\
>  	if ((bio)->bi_disk != (bdev)->bd_disk)	\
>  		bio_clear_flag(bio, BIO_THROTTLED);\

Generally looks okay to me but I'm not sure about bio_set_dev_only().
Maybe sth more explicit like bio_set_dev_without_blkg()?  Also, can
you please add comments explaining which should be used when?

Thanks.

-- 
tejun
