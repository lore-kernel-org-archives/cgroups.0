From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cpuset: decouple cpuset locking from cgroup core,
	take#2
Date: Mon, 7 Jan 2013 08:44:53 -0800
Message-ID: <20130107164453.GH3926@htj.dyndns.org>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
	<50E93554.3070102@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=nlvg80LXV7WHHoqiBJFWxqH+swfT280NcMdvt/70UVI=;
	b=ascV3WFFTM9hu0FnWxl57VrvjnyWB5uqInDaGejS1rUmumbK7g2gKcZzl7iqU5VFBb
	y4OVDgJ/+OlJyUeZ/qMCUdDvrBPnm7xDCHOT/H4hCZVdsWRQWJshRv3g44/TqbgfmxBf
	u3RAa2SDiCCq+zUbAGI0JkdfSOVwi1bXu9d4xdRg+xCI5BHFDttBHsdCBDsLgAdcgFx8
	mJIb2mHAMTNN8zPRE7Prquymi6rQfW6RyoWdY57u8RacJRJqL2R+V4v+2+FG9AYpYqbf
	nnbkcYe5Hr6xf0uJ/fCPltUuDSl2wWgi8K6iAN9V2/wxckZeS8c/KO32Zm0qQxxcJaxY
	DLlA==
Content-Disposition: inline
In-Reply-To: <50E93554.3070102-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Li.

On Sun, Jan 06, 2013 at 04:27:00PM +0800, Li Zefan wrote:
> I've reviewed and tested the patchset, and it looks good to me!
> 
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Great.  Ummm... How should we route this?  Paul doesn't seem to be
looking at this.  I can route it through cgroup tree.  Any objections?

Thanks.

-- 
tejun
