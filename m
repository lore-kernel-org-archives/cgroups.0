From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/12] cgroup: unify pidlist and other file handling
Date: Wed, 4 Dec 2013 08:08:53 -0500
Message-ID: <20131204130853.GF3158@htj.dyndns.org>
References: <1385595759-17656-1-git-send-email-tj@kernel.org>
	<1385595759-17656-13-git-send-email-tj@kernel.org>
	<529EC9A6.903@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=9x7Kh942aK+pLP17VW9zGIRneAvNgIiEeimdjfNq1y4=;
	b=NXr1kv5fujwE9JYivCl+nTNVF+84q2qhfviigPoYWYzTj0C2+/UeB6gLJNIKjToORB
	cfSPpwUPkTNhgmqMKlpzWaWl0+/PPuUaCjXm6eGT0Yhl9TfYBahFy+QiyiV9tkfFm80W
	Dibc5g9iHlpxBX7scB1Sf9ldlaX9csrZPwij4qVHD3Ke1o5rs8JG9iQ836bqQ7gkmLl5
	gnZv49h06XmAllutSbM5/EpSOkywLhth7vqkFPizjvi5wpkNV08+6TKll0zggCnpSqLU
	wzteV0Cdj/K6UkazaGWXaBNMqItFraT5qRscmaP1AuY2uC30c4xy1EBrcgW4ls77/1Aa
	GwEg==
Content-Disposition: inline
In-Reply-To: <529EC9A6.903-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, Dec 04, 2013 at 02:20:22PM +0800, Li Zefan wrote:
> > +static void *cgroup_seqfile_start(struct seq_file *seq, loff_t *ppos)
> > +{
> > +	struct cftype *cft = seq_cft(seq);
> > +
> > +	if (cft->seq_start) {
> > +		return cft->seq_start(seq, ppos);
> > +	} else {
> > +		/*
> > +		 * The same behavior and code as single_open().  Returns
> > +		 * !NULL if pos is at the beginning; otherwise, NULL.
> > +		 */
> 
> Isn't it simpler to choose between seq_open() and single_open() depending
> on if cft->seq_start is implemented?

This is primarily to duplicate and match kernfs implementation and
will be removed when cgroup transitions to kernfs.  As for whether
kernfs could have used different open paths.  Maybe.  I don't think
either way is particularly better tho especially given that
seq_open*() and single_open*() interfaces don't match each other.  It
gets confusing pretty fast once you start mixing the two variants.

Thanks.

-- 
tejun
