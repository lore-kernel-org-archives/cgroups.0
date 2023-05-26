From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v2 6/6] blk-sysfs: add a new attr_group for blk_mq
Date: Fri, 26 May 2023 17:38:10 +0800
Message-ID: <8cafbd02-182a-4071-7e04-cc6f96045852@huaweicloud.com>
References: <20230512093554.911753-1-yukuai1@huaweicloud.com>
 <20230512093554.911753-7-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230512093554.911753-7-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Christoph

=D4=DA 2023/05/12 17:35, Yu Kuai =D0=B4=B5=C0:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Currently wbt sysfs entry is created for bio based device, and wbt can
> be enabled for such device through sysfs while it doesn't make sense
> because wbt can only work for rq based device. In the meantime, there
> are other similar sysfs entries.
>=20
> Fix this by adding a new attr_group for blk_mq, and sysfs entries will
> only be created when the device is rq based.
>=20
> Suggested-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Any comments about this patch?

Thanks,
Kuai
> ---
>   block/blk-sysfs.c | 42 +++++++++++++++++++++++++++++++-----------
>   1 file changed, 31 insertions(+), 11 deletions(-)
>=20
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 6c1c4ba66bc0..afc797fb0dfc 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -621,7 +621,6 @@ QUEUE_RW_ENTRY(queue_wb_lat, "wbt_lat_usec");
>   #endif
>  =20
>   static struct attribute *queue_attrs[] =3D {
> -	&queue_requests_entry.attr,
>   	&queue_ra_entry.attr,
>   	&queue_max_hw_sectors_entry.attr,
>   	&queue_max_sectors_entry.attr,
> @@ -629,7 +628,6 @@ static struct attribute *queue_attrs[] =3D {
>   	&queue_max_discard_segments_entry.attr,
>   	&queue_max_integrity_segments_entry.attr,
>   	&queue_max_segment_size_entry.attr,
> -	&elv_iosched_entry.attr,
>   	&queue_hw_sector_size_entry.attr,
>   	&queue_logical_block_size_entry.attr,
>   	&queue_physical_block_size_entry.attr,
> @@ -650,7 +648,6 @@ static struct attribute *queue_attrs[] =3D {
>   	&queue_max_open_zones_entry.attr,
>   	&queue_max_active_zones_entry.attr,
>   	&queue_nomerges_entry.attr,
> -	&queue_rq_affinity_entry.attr,
>   	&queue_iostats_entry.attr,
>   	&queue_stable_writes_entry.attr,
>   	&queue_random_entry.attr,
> @@ -658,11 +655,7 @@ static struct attribute *queue_attrs[] =3D {
>   	&queue_wc_entry.attr,
>   	&queue_fua_entry.attr,
>   	&queue_dax_entry.attr,
> -#ifdef CONFIG_BLK_WBT
> -	&queue_wb_lat_entry.attr,
> -#endif
>   	&queue_poll_delay_entry.attr,
> -	&queue_io_timeout_entry.attr,
>   #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
>   	&blk_throtl_sample_time_entry.attr,
>   #endif
> @@ -671,16 +664,23 @@ static struct attribute *queue_attrs[] =3D {
>   	NULL,
>   };
>  =20
> +static struct attribute *blk_mq_queue_attrs[] =3D {
> +	&queue_requests_entry.attr,
> +	&elv_iosched_entry.attr,
> +	&queue_rq_affinity_entry.attr,
> +	&queue_io_timeout_entry.attr,
> +#ifdef CONFIG_BLK_WBT
> +	&queue_wb_lat_entry.attr,
> +#endif
> +	NULL,
> +};
> +
>   static umode_t queue_attr_visible(struct kobject *kobj, struct attribut=
e *attr,
>   				int n)
>   {
>   	struct gendisk *disk =3D container_of(kobj, struct gendisk, queue_kobj=
);
>   	struct request_queue *q =3D disk->queue;
>  =20
> -	if (attr =3D=3D &queue_io_timeout_entry.attr &&
> -		(!q->mq_ops || !q->mq_ops->timeout))
> -			return 0;
> -
>   	if ((attr =3D=3D &queue_max_open_zones_entry.attr ||
>   	     attr =3D=3D &queue_max_active_zones_entry.attr) &&
>   	    !blk_queue_is_zoned(q))
> @@ -689,11 +689,30 @@ static umode_t queue_attr_visible(struct kobject *k=
obj, struct attribute *attr,
>   	return attr->mode;
>   }
>  =20
> +static umode_t blk_mq_queue_attr_visible(struct kobject *kobj,
> +					 struct attribute *attr, int n)
> +{
> +	struct gendisk *disk =3D container_of(kobj, struct gendisk, queue_kobj);
> +	struct request_queue *q =3D disk->queue;
> +
> +	if (!queue_is_mq(q))
> +		return 0;
> +
> +	if (attr =3D=3D &queue_io_timeout_entry.attr && !q->mq_ops->timeout)
> +		return 0;
> +
> +	return attr->mode;
> +}
> +
>   static struct attribute_group queue_attr_group =3D {
>   	.attrs =3D queue_attrs,
>   	.is_visible =3D queue_attr_visible,
>   };
>  =20
> +static struct attribute_group blk_mq_queue_attr_group =3D {
> +	.attrs =3D blk_mq_queue_attrs,
> +	.is_visible =3D blk_mq_queue_attr_visible,
> +};
>  =20
>   #define to_queue(atr) container_of((atr), struct queue_sysfs_entry, att=
r)
>  =20
> @@ -738,6 +757,7 @@ static const struct sysfs_ops queue_sysfs_ops =3D {
>  =20
>   static const struct attribute_group *blk_queue_attr_groups[] =3D {
>   	&queue_attr_group,
> +	&blk_mq_queue_attr_group,
>   	NULL
>   };
>  =20
>=20

