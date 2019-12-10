/**
 * Created by max on 4/16/16.
 */
package feathersx.layout
{
import feathers.core.FeathersControl;
import feathers.core.IFeathersDisplayObject;
import feathers.layout.ILayoutData;
import feathers.layout.ILayoutDisplayObject;

import mx.core.IMXMLObject;

import starling.display.Quad;

public class Spacer extends FeathersControl implements IFeathersDisplayObject, ILayoutDisplayObject, IMXMLObject
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Spacer(layoutData:ILayoutData = null, width:Number=NaN, height:Number=NaN, maxWidth:Number=Number.POSITIVE_INFINITY, maxHeight:Number=Number.POSITIVE_INFINITY)
    {
        super();

        this.layoutData = layoutData;

        this.width = width;
        this.height = height;
        this.maxWidth = maxWidth;
        this.maxHeight = maxHeight;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected var background:Quad;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  color
    //-------------------------------------

    private var _color:int = -1;

    public function get color():int
    {
        return _color;
    }

    public function set color(value:int):void
    {
        if (value == _color) return;
        _color = value;
        invalidate(INVALIDATION_FLAG_DATA);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize():void
    {
        super.initialize();
    }

    override protected function draw():void
    {
        super.draw();

        var dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
        var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);

        if (dataInvalid || sizeInvalid)
        {
            if (_color > -1 && actualWidth > 0 && actualHeight > 0)
            {
                if (background == null)
                {
                    background = new Quad(actualWidth, actualHeight, _color);
                    addChild(background);
                }
                else
                {
                    background.width = actualWidth;
                    background.height = actualHeight;
                }
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    public function initialized(document: Object, id: String): void {

    }
}
}
