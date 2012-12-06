From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup_rm_file: don't delete the uncreated files
Date: Thu, 6 Dec 2012 08:59:39 -0800
Message-ID: <20121206165939.GN19802@htj.dyndns.org>
References: <1354775937-2625-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=ljLmHSWDoyZxdJ6Uqna2zZRwtGncSXzt3vZ4wCg4rj8=;
	b=JiYS5+JivaskM8PznJ25NbtDRRmKRfdkstQNWdJk1jB2hbPk+P5VF83UQIe1fGLM0o
	CxankDZmqXM032N2odbC1xpvpeOBNp9jMiz+CNmVmA69VHtUC3WKjfga36GkOQpJ4OVR
	aib33OI2qgY3HKtElU7y0/TO87ZNkCoZCTV6zUaxa5SMJPuGvFeCxqUQK7yGCRjdg4LC
	QiB4Hc4I8m89KWwR9t1ieI57P6pcgVnAiGjgmGPgUvmychG006+QhRsrAFd8tFBznKO5
	A4rzAu/vWctwV8zFaNu4nqXtgVeERE8IZwqZGtt20TgpGgKX5jPR+cuNiaLI4DWM2jt6
	CtJQ==
Content-Disposition: inline
In-Reply-To: <1354775937-2625-1-git-send-email-gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
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
To: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, Dec 06, 2012 at 02:38:57PM +0800, Gao feng wrote:
> in cgroup_add_file,when creating files for cgroup,
> some of creation may be skipped. So we need to avoid
> deleting these uncreated files in cgroup_rm_file,
> otherwise the warning msg will be triggered.
> 
> "cgroup_addrm_files: failed to remove memory_pressure_enabled, err=-2"
> 
> Signed-off-by: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Applied to cgroup/for-3.8 w/ Li's ack and cc to stable added.

Thanks!

-- 
tejun
