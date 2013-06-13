From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
Date: Wed, 12 Jun 2013 19:38:31 -0700
Message-ID: <20130613023831.GB10979@localhost>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
	<1371070996-20613-5-git-send-email-tj@kernel.org>
	<51B93038.9010202@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=ymLhcS1PrG6BlH1Oy6cbZDrfGE6Kb5jburaG/I4q8DI=;
	b=evaIXSmuN50qszm0sSR06v0WjBgMy/v0uRpXDKXsgEmG/sZCO7evPOWhfAvD9bsaJL
	CDwFVyCslJZeksiafuK/Wf8+SjBq8UvzZ9iNJPHyJ+7BQduHsOI/0j7I35alN5jpYN+V
	w7mIsrPUcbVX4Ui4hXWLRAf7KanpvEYX7OxMf5QGFWgrss5GxX2uoIxIK8hRAl+2odUB
	M3ofplE26JOIO/CIzd7NKnFC070uM08YkAMSQKOz7APJNmfwyXTJGZr2+Lbmp6fa7OjH
	KiKZ/R9OgVt8D6uZnqQsa+jTbDlX7IhCvIMeZS5x49dBLH/72Liwv/hAS6ZUQnKK4qIi
	InIA==
Content-Disposition: inline
In-Reply-To: <51B93038.9010202-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 13, 2013 at 10:36:40AM +0800, Li Zefan wrote:
> On 2013/6/13 5:03, Tejun Heo wrote:
> > There's no point in using kmalloc() and list_del() instead of the
> > clearing variants for trivial stuff.  We can live dangerously
> > elsewhere.  Use kzalloc() and list_del_init() instead and drop 0
> > inits.
> > 
> 
> Do you mean we prefer list_del_init() than list_del() in general? Then
> in which cases do we prefer list_del()?

IMO, list_del() is preferred when the object shouldn't be reused (i.e.
it gets taken off a list and then it's freed). list_del_init() could
hide bugs.
